document.addEventListener("scroll", () => {
  const logo = document.getElementById("logo");
  const logoText = logo?.querySelector("a");
  const topNav = document.getElementById("top-nav");
  const navContainer = document.getElementById("nav-container");

  if (window.scrollY > 0) {
    if (topNav) topNav.classList.replace("text-md", "text-sm");
    if (logoText) {
      logoText.classList.replace("text-5xl", "text-4xl");
      logoText.classList.add("scale-95");
    }
    if (navContainer) {
      navContainer.classList.replace("pt-4", "pt-2");
      navContainer.classList.replace("pb-2", "pb-1");
    }
  } else {
    if (topNav) topNav.classList.replace("text-sm", "text-md");
    if (logoText) {
      logoText.classList.replace("text-4xl", "text-5xl");
      logoText.classList.remove("scale-95");
    }
    if (navContainer) {
      navContainer.classList.replace("pt-2", "pt-4");
      navContainer.classList.replace("pb-1", "pb-2");
    }
  }
});
