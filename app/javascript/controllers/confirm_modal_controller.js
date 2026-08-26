import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["modal", "message", "form", "method"];

  open(event) {
    event.preventDefault();

    this.messageTarget.textContent = event.currentTarget.dataset.message;
    this.formTarget.action = event.currentTarget.dataset.url;

    const method = event.currentTarget.dataset.method || "post";
    this.methodTarget.value = method;

    this.modalTarget.classList.remove("hidden");
    this.modalTarget.classList.add("flex");
  }

  close() {
    this.modalTarget.classList.remove("flex");
    this.modalTarget.classList.add("hidden");
  }
}
