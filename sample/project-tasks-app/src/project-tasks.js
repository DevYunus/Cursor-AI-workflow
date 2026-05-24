const ROLE_RANK = {
  viewer: 1,
  member: 2,
  manager: 3,
  admin: 4,
};

const STATUS_TRANSITIONS = {
  todo: new Set(["in_progress"]),
  in_progress: new Set(["done", "todo"]),
  done: new Set([]),
};

export function createProjectTaskSystem({
  workspaceId = "workspace_1",
  today = "2026-05-24",
  members = [],
} = {}) {
  const state = {
    workspaceId,
    today,
    members: members.map((member) => ({ ...member })),
    projects: [],
    tasks: [],
    auditLog: [],
  };

  function createProject({ actorId, name }) {
    const actor = requireMember(state, actorId);
    requireRole(actor, "manager", "create projects");

    const normalizedName = normalizeName(name, "Project name");
    const duplicate = state.projects.find(
      (project) => project.normalizedName === normalizedName
    );

    if (duplicate) {
      throw new Error("Project names must be unique inside a workspace");
    }

    const project = {
      id: `project_${state.projects.length + 1}`,
      name: name.trim(),
      normalizedName,
      createdBy: actorId,
    };

    state.projects.push(project);
    recordAudit(state, actorId, "project.created", { projectId: project.id });

    return { ...project };
  }

  function createTask({ actorId, projectId, title, assigneeId, dueDate }) {
    const actor = requireMember(state, actorId);
    requireRole(actor, "manager", "create project tasks");
    const project = requireProject(state, projectId);
    const assignee = requireMember(state, assigneeId);
    const trimmedTitle = normalizeText(title, "Task title");

    if (!isIsoDate(dueDate)) {
      throw new Error("Due date must be YYYY-MM-DD");
    }

    if (dueDate < state.today) {
      throw new Error("Task due date cannot be in the past");
    }

    const task = {
      id: `task_${state.tasks.length + 1}`,
      projectId: project.id,
      title: trimmedTitle,
      assigneeId: assignee.id,
      status: "todo",
      dueDate,
      createdBy: actorId,
    };

    state.tasks.push(task);
    recordAudit(state, actorId, "task.created", {
      projectId: project.id,
      taskId: task.id,
      assigneeId: assignee.id,
    });

    return { ...task };
  }

  function updateTaskStatus({ actorId, taskId, status }) {
    const actor = requireMember(state, actorId);
    const task = requireTask(state, taskId);

    if (actor.id !== task.assigneeId && ROLE_RANK[actor.role] < ROLE_RANK.manager) {
      throw new Error("Only the assignee or a manager can update task status");
    }

    const allowedNextStatuses = STATUS_TRANSITIONS[task.status];
    if (!allowedNextStatuses || !allowedNextStatuses.has(status)) {
      throw new Error(`Cannot move task from ${task.status} to ${status}`);
    }

    task.status = status;
    recordAudit(state, actorId, "task.status_changed", { taskId, status });

    return { ...task };
  }

  return {
    state,
    createProject,
    createTask,
    updateTaskStatus,
  };
}

function requireMember(state, memberId) {
  const member = state.members.find((candidate) => candidate.id === memberId);

  if (!member) {
    throw new Error("Member must belong to the workspace");
  }

  return member;
}

function requireProject(state, projectId) {
  const project = state.projects.find((candidate) => candidate.id === projectId);

  if (!project) {
    throw new Error("Project does not exist");
  }

  return project;
}

function requireTask(state, taskId) {
  const task = state.tasks.find((candidate) => candidate.id === taskId);

  if (!task) {
    throw new Error("Task does not exist");
  }

  return task;
}

function requireRole(member, minimumRole, action) {
  if (ROLE_RANK[member.role] < ROLE_RANK[minimumRole]) {
    throw new Error(`Only ${minimumRole}s and admins can ${action}`);
  }
}

function normalizeName(value, label) {
  return normalizeText(value, label).toLowerCase();
}

function normalizeText(value, label) {
  const text = String(value || "").trim();

  if (!text) {
    throw new Error(`${label} is required`);
  }

  return text;
}

function isIsoDate(value) {
  return /^\d{4}-\d{2}-\d{2}$/.test(String(value || ""));
}

function recordAudit(state, actorId, event, metadata) {
  state.auditLog.push({
    event,
    actorId,
    metadata,
  });
}
