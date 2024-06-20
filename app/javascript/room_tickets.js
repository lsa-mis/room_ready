document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("tdx_form");
  const descriptionField = document.getElementById("description_field");

  if (form) {
    form.addEventListener("submit", async (event) => {
      event.preventDefault(); // Prevent default form submission

      const editorContent = descriptionField.value.trim();
      if (!editorContent) {
        alert("Description field cannot be blank.");
        return;
      }

      // Gather form data
      const formData = new FormData(form);

      try {
        // Send data using Fetch API
        const response = await fetch(form.action, {
          method: form.method,
          headers: {
            'Accept': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          },
          body: formData
        });

        const data = await response.json();
        if (response.ok) {
          alert(data.notice);
          form.reset();
        } else {
          alert(data.errors.join(", "));
        }
      } catch (error) {
        console.error("Error submitting form", error);
        alert("An error occurred while submitting the form.");
      }
    });
  }
});
