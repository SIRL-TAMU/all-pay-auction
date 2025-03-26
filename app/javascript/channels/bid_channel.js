import consumer from "channels/consumer";

document.addEventListener("DOMContentLoaded", () => {
  const auctionItemContainer = document.querySelector(
    ".auction-item-container"
  );

  if (!auctionItemContainer) return;

  const auctionItemId = auctionItemContainer.dataset.auctionItemId;

  consumer.subscriptions.create(
    { channel: "BidChannel", auction_item_id: auctionItemId },
    {
      connected() {
        console.log("Connected to BidChannel for item", auctionItemId);
      },

      disconnected() {
        console.log("Disconnected from BidChannel");
      },

      received(data) {
        console.log("Received new bid:", data);

        // Update max bid
        const maxBidEl = document.getElementById("max-bid");
        if (maxBidEl) {
          maxBidEl.textContent = `$${parseFloat(data.amount).toFixed(2)} USD`;
        }

        // Update total bids
        const totalBidsEl = document.getElementById("total-bids");
        if (totalBidsEl) {
          totalBidsEl.textContent = `${data.total_bids} bids`;
        }

        const bidInput = document.querySelector(".auction-item-bid-input");
        if (bidInput) {
          const minIncrement = parseFloat(
            bidInput.dataset.minIncrement || "0.01"
          );
          const newMin = parseFloat(data.amount) + minIncrement;
          bidInput.min = newMin.toFixed(2);
        }

        // Prepend bid to history
        const bidHistory = document.querySelector(".auction-item-bid-history");
        if (bidHistory) {
          const newBid = document.createElement("div");
          newBid.className = "auction-item-bid-entry";
          newBid.innerHTML = `
            <div class="auction-item-user-card">
              <p>${data.buyer_name}</p>
              <p class="auction-item-user-card-subtext">${data.created_at}</p>
            </div>
            <p class="auction-item-user-card-amount">
              <strong>$${parseFloat(data.amount).toFixed(2)} USD</strong>
            </p>
          `;
          bidHistory
            .querySelector(".auction-item-user-card-title")
            .after(newBid);
        }
      },
    }
  );
});
