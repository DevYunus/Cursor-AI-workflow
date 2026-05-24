import assert from "node:assert/strict";
import {
  createMailer,
  resetContactFormState,
  submitContactForm,
} from "../src/contact-form.js";

resetContactFormState();

const mailer = createMailer();
const payload = {
  email: "SAM@example.com",
  message: "Please call me back.",
  requestId: "req_123",
};

assert.deepEqual(submitContactForm(payload, mailer), { ok: true });
assert.deepEqual(submitContactForm(payload, mailer), { ok: true });
assert.equal(mailer.sent.length, 1, "duplicate submit should send one confirmation");
assert.equal(mailer.sent[0].email, "sam@example.com");

console.log("ok - duplicate contact submits are idempotent");
