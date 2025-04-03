document.addEventListener("DOMContentLoaded", () => {
  const container = document.getElementById("auction-carousel");
  const btnLeft = document.getElementById("auction-left");
  const btnRight = document.getElementById("auction-right");
  const loader = document.getElementById("auction-loader");
  let page = 1;
  let loading = false;
  let reachedEnd = false;

  const updateButtons = () => {
    btnLeft.disabled = container.scrollLeft <= 0;
    btnRight.disabled =
      container.scrollLeft + container.offsetWidth >=
        container.scrollWidth - 10 || reachedEnd;
  };

  const loadMoreItems = () => {
    if (loading || reachedEnd) return;
    loading = true;
    loader.classList.remove("hidden");

    fetch(`/load_auction_items?page=${page + 1}`, {
      headers: { Accept: "text/html" },
    })
      .then((response) => {
        if (!response.ok) throw new Error("Failed to load more items.");
        return response.text();
      })
      .then((html) => {
        if (html.trim().length === 0) {
          reachedEnd = true;
        } else {
          page += 1;
          const temp = document.createElement("div");
          temp.innerHTML = html;
          const items = temp.querySelectorAll(".carousel-item");
          items.forEach((el) => container.appendChild(el));
        }
      })
      .catch(console.error)
      .finally(() => {
        loading = false;
        loader.classList.add("hidden");
        updateButtons();
      });
  };

  btnLeft.addEventListener("click", () => {
    container.scrollBy({ left: -300, behavior: "smooth" });
  });

  btnRight.addEventListener("click", () => {
    container.scrollBy({ left: 300, behavior: "smooth" });
    if (
      !reachedEnd &&
      container.scrollLeft + container.offsetWidth >=
        container.scrollWidth - 100
    ) {
      loadMoreItems();
    }
  });

  container.addEventListener("scroll", updateButtons);
  updateButtons();
});
