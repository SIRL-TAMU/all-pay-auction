# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application"
pin "@rails/ujs", to: "https://cdn.skypack.dev/@rails/ujs"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
