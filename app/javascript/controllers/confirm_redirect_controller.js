import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Map Redirect controller connected");
  }

  onMapClick() {
    if (confirm("This will open Google Maps")) {
      window.location.href = this.element.getAttribute("data-url");
    } else {
      return;
    }
  }
}
