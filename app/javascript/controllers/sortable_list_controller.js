import { Controller } from "@hotwired/stimulus";
import Sortable from "sortablejs";

export default class extends Controller {
  static values = {
    url: String,
  };

  connect() {
    this.sortable = Sortable.create(this.element, {
      animation: 150,
      onEnd: () => {
        this.saveOrder();
      },
    });
  }

  disconnect() {
    if (this.sortable) this.sortable.destroy();
  }

  saveOrder() {
    const orderedIds = Array.from(
      this.element.querySelectorAll("[data-assignment-id]"),
    ).map((el) => el.dataset.assignmentId);

    fetch(this.urlValue, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')
          .content,
        Accept: "application/json",
      },
      body: JSON.stringify({ ordered_ids: orderedIds }),
    });
  }
}
