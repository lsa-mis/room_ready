import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "description"];

  connect() {
    console.log("Hello World!");
  }
  async check(event){
    console.log("check");
    event.preventDefault(); // Prevent default form submission
    if (this.descriptionTarget.value.trim() === ""){
      alert("Description field cannot be blank.");
      return;
    }
    // Gather form data
    const formData = new FormData(this.formTarget);
    try {
      // Send data using Fetch API
      const response = await fetch(this.formTarget.action, {
        method: this.formTarget.method,
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        },
        body: formData
      });
      const data = await response.json();
      if (response.ok) {
        alert(data.notice);
        this.formTarget.reset();
      } else {
        alert(data.errors.join(", "));
      }
    } 
    catch (error) {
      console.error("Error submitting form", error);
      alert("An error occurred while submitting the form.");
    }
  }
}