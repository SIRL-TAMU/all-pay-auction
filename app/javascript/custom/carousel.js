document.addEventListener("DOMContentLoaded", () => {
  const container = document.getElementById("auction-carousel");
  const btnLeft = document.getElementById("auction-left");
  const btnRight = document.getElementById("auction-right");

  const updateButtons = () => {
    btnLeft.disabled = container.scrollLeft <= 0;
    btnRight.disabled =
      container.scrollLeft + container.offsetWidth >=
      container.scrollWidth - 10;
  };

  btnLeft.addEventListener("click", () => {
    container.scrollBy({ left: -200, behavior: "smooth" });
  });

  btnRight.addEventListener("click", () => {
    container.scrollBy({ left: 200, behavior: "smooth" });
  });

  container.addEventListener("scroll", updateButtons);
  updateButtons();
});
