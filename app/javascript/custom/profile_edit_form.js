document.addEventListener("DOMContentLoaded", () => {
  const infoDisplay = document.getElementById("info-display");
  const editForm = document.getElementById("edit-info-form");
  const passwordForm = document.getElementById("change-password-form");

  document.getElementById("edit-info-btn").addEventListener("click", () => {
    infoDisplay.classList.add("hidden");
    passwordForm.classList.add("hidden");
    editForm.classList.remove("hidden");
  });

  document
    .getElementById("change-password-btn")
    .addEventListener("click", () => {
      infoDisplay.classList.add("hidden");
      editForm.classList.add("hidden");
      passwordForm.classList.remove("hidden");
    });

  document.getElementById("cancel-edit").addEventListener("click", () => {
    editForm.classList.add("hidden");
    infoDisplay.classList.remove("hidden");
  });

  document.getElementById("cancel-password").addEventListener("click", () => {
    passwordForm.classList.add("hidden");
    infoDisplay.classList.remove("hidden");
  });
});

document.addEventListener("DOMContentLoaded", () => {
  const addForm = document.getElementById("add-form");
  const withdrawForm = document.getElementById("withdraw-form");

  document.getElementById("add-btn").addEventListener("click", () => {
    addForm.classList.remove("hidden");
    withdrawForm.classList.add("hidden");
  });

  document.getElementById("withdraw-btn").addEventListener("click", () => {
    withdrawForm.classList.remove("hidden");
    addForm.classList.add("hidden");
  });
});
