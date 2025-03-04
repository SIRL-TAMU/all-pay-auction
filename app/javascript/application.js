import Rails from "@rails/ujs";

Rails.start();

// BROKEN: JAVASCRIPT IS NOT BEING CONNECTED CORRECTLY
document.addEventListener("DOMContentLoaded", function () {
  const fileInput = document.querySelector("input[type='file']");
  const previewContainer = document.querySelector(".product-image-container");

  fileInput.addEventListener("change", function () {
    previewContainer.innerHTML = "";
    Array.from(fileInput.files).forEach((file) => {
      const reader = new FileReader();
      reader.onload = function (e) {
        const img = document.createElement("img");
        img.src = e.target.result;
        img.classList.add("product-image");
        previewContainer.appendChild(img);
      };
      reader.readAsDataURL(file);
    });
  });
});
