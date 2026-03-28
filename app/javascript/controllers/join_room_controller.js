import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="join-room"
export default class extends Controller {
  static targets = ["form", "roomCode"];

  submit(event) {
    event.preventDefault();

    const code = this.roomCodeTarget.value.trim();

    if (!code) return;

    this.formTarget.action = `/rooms/${code}/join`;
    this.formTarget.submit();
  }
}
