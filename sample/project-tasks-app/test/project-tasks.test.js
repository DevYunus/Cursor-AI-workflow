import assert from "node:assert/strict";
import { createProjectTaskSystem } from "../src/project-tasks.js";

function makeSystem() {
  return createProjectTaskSystem({
    today: "2026-05-24",
    members: [
      { id: "u_admin", email: "admin@example.com", role: "admin" },
      { id: "u_manager", email: "manager@example.com", role: "manager" },
      { id: "u_member", email: "member@example.com", role: "member" },
      { id: "u_viewer", email: "viewer@example.com", role: "viewer" },
    ],
  });
}

{
  const system = makeSystem();

  const project = system.createProject({
    actorId: "u_manager",
    name: "Client Onboarding",
  });

  assert.equal(project.id, "project_1");
  assert.equal(system.state.auditLog[0].event, "project.created");
}

{
  const system = makeSystem();

  system.createProject({ actorId: "u_admin", name: "Client Onboarding" });

  assert.throws(
    () => system.createProject({ actorId: "u_admin", name: " client onboarding " }),
    /unique/
  );
}

{
  const system = makeSystem();

  assert.throws(
    () => system.createProject({ actorId: "u_member", name: "Tax Prep" }),
    /Only managers and admins/
  );
}

{
  const system = makeSystem();
  const project = system.createProject({ actorId: "u_admin", name: "Tax Prep" });

  const task = system.createTask({
    actorId: "u_manager",
    projectId: project.id,
    title: "Upload prior-year return",
    assigneeId: "u_member",
    dueDate: "2026-06-01",
  });

  assert.equal(task.status, "todo");
  assert.equal(system.state.auditLog.at(-1).event, "task.created");
}

{
  const system = makeSystem();
  const project = system.createProject({ actorId: "u_admin", name: "Tax Prep" });

  assert.throws(
    () =>
      system.createTask({
        actorId: "u_manager",
        projectId: project.id,
        title: "Upload prior-year return",
        assigneeId: "u_missing",
        dueDate: "2026-06-01",
      }),
    /workspace/
  );

  assert.throws(
    () =>
      system.createTask({
        actorId: "u_manager",
        projectId: project.id,
        title: "Upload prior-year return",
        assigneeId: "u_member",
        dueDate: "2026-05-01",
      }),
    /past/
  );
}

{
  const system = makeSystem();
  const project = system.createProject({ actorId: "u_admin", name: "Tax Prep" });
  const task = system.createTask({
    actorId: "u_manager",
    projectId: project.id,
    title: "Upload prior-year return",
    assigneeId: "u_member",
    dueDate: "2026-06-01",
  });

  const started = system.updateTaskStatus({
    actorId: "u_member",
    taskId: task.id,
    status: "in_progress",
  });
  const done = system.updateTaskStatus({
    actorId: "u_manager",
    taskId: task.id,
    status: "done",
  });

  assert.equal(started.status, "in_progress");
  assert.equal(done.status, "done");
  assert.equal(system.state.auditLog.at(-1).event, "task.status_changed");

  assert.throws(
    () =>
      system.updateTaskStatus({
        actorId: "u_member",
        taskId: task.id,
        status: "todo",
      }),
    /Cannot move/
  );
}

console.log("ok - project and task workflows enforce roles, validation, and audit logs");
