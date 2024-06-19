document.addEventListener("turbo:load", () => {
    const form = document.getElementById("tdx_form");
    const submitButton = document.getElementById("submit_button");
    const descriptionField = document.getElementById("description_field");
  
    form.addEventListener("submit", (event) => {
      const editorContent = descriptionField.value.trim();
  
      if (!editorContent) {
        event.preventDefault(); // Prevent form submission
        alert("Description field cannot be blank.");
      }
    });
  
    document.addEventListener("ajax:success", (event) => {
      const detail = event.detail;
      const data = detail[0], status = detail[1], xhr = detail[2];
  
      if (status === "OK") {
        // Close the modal
        const modalElement = document.getElementById('exampleModal');
        const modalInstance = bootstrap.Modal.getInstance(modalElement);
        modalInstance.hide();
  
        // Optionally, you can show a success message or perform other actions
      }
    });
  
    document.addEventListener("ajax:error", (event) => {
      const detail = event.detail;
      const data = detail[0], status = detail[1], xhr = detail[2];
  
      // Handle errors here
      console.error("Form submission failed:", data);
    });
  });
