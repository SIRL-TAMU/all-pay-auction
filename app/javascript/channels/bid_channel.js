import consumer from "channels/consumer";

document.addEventListener("DOMContentLoaded", () => {
  const auctionItemContainer = document.querySelector(
    ".auction-item-container"
  );
  if (!auctionItemContainer) return;

  const auctionItemId = auctionItemContainer.dataset.auctionItemId;
  const namesVisible = auctionItemContainer.dataset.namesVisible === "true";
  const bidAmountVisible =
    auctionItemContainer.dataset.bidAmountVisible === "true";
  const isSeller = auctionItemContainer.dataset.isSeller === "true";
  const currentUserId = parseInt(auctionItemContainer.dataset.currentUserId);
  const minIncrement = parseFloat(
    auctionItemContainer.dataset.minIncrement || "0.01"
  );

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

        // Update min bid input (Alpine.js component)
        const alpineBidComponent = document.querySelector("[x-data]");
        if (alpineBidComponent && window.Alpine) {
          const component = Alpine.$data(alpineBidComponent);
          const newMin = parseFloat(data.amount) + minIncrement;
          component.selectedValue = newMin;
          component.selectedText = `$${newMin.toFixed(2)} USD`;
        }

        // Prepend bid to history
        const bidHistory = document.querySelector(".auction-item-bid-history");
        if (bidHistory) {
          const newBid = document.createElement("div");
          newBid.className = "auction-item-bid-entry";

          // Buyer name logic
          let buyerName = data.buyer_name;
          if (!namesVisible && !isSeller && currentUserId !== data.buyer_id) {
            buyerName = "Anonymous Bidder";
          } else if (currentUserId === data.buyer_id) {
            buyerName += " (You)";
          }

          // Amount logic
          let amountDisplay = `<strong>$${parseFloat(data.amount).toFixed(
            2
          )} USD</strong>`;
          if (
            !bidAmountVisible &&
            !isSeller &&
            currentUserId !== data.buyer_id
          ) {
            amountDisplay = `<strong><em>Amount Hidden</em></strong>`;
          }

          const formatToLocalTime = (isoString) => {
            const date = new Date(isoString);
            const options = {
              year: "numeric",
              month: "short",
              day: "2-digit",
              hour: "2-digit",
              minute: "2-digit",
              hour12: true,
            };
            return date.toLocaleString(undefined, options).replace(",", " at");
          };

          const createdAtLocal = formatToLocalTime(data.created_at);

          newBid.innerHTML = `
            <div class="auction-item-user-card">
              <p>${buyerName}</p>
              <p class="auction-item-user-card-subtext">${createdAtLocal}</p>
            </div>
            <p class="auction-item-user-card-amount">
              ${amountDisplay}
            </p>
          `;

          const scrollContainer = bidHistory.querySelector(
            ".auction-bid-scroll"
          );
          if (scrollContainer) {
            scrollContainer.insertBefore(newBid, scrollContainer.firstChild);

            if (scrollContainer.scrollTop === 0) {
              scrollContainer.scrollTop = 0;
            }
          }
        }
      },
    }
  );
});
