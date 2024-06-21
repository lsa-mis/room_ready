window.onload = () => {
  const redirectLink = document.getElementById("redirect-to-maps");
  redirectLink.addEventListener("click", () => {
    if (confirm("This will open Google Maps")) {
      window.location.href = redirectLink.getAttribute("data-url");
    } else {
      return;
    }
  });
};
