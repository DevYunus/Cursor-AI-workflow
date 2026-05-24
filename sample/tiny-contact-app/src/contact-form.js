const sentConfirmationKeys = new Set();

export function createMailer() {
  const sent = [];

  return {
    sent,
    sendConfirmation(email, message) {
      sent.push({ email, message });
    },
  };
}

export function submitContactForm(input, mailer) {
  const email = String(input.email || "").trim().toLowerCase();
  const message = String(input.message || "").trim();
  const requestId = String(input.requestId || "").trim();

  if (!email || !message || !requestId) {
    return { ok: false, error: "email, message, and requestId are required" };
  }

  const confirmationKey = `${email}:${requestId}`;
  if (!sentConfirmationKeys.has(confirmationKey)) {
    mailer.sendConfirmation(email, message);
    sentConfirmationKeys.add(confirmationKey);
  }

  return { ok: true };
}

export function resetContactFormState() {
  sentConfirmationKeys.clear();
}
