# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application"
pin "@rails/ujs", to: "https://cdn.skypack.dev/@rails/ujs"
pin "@rails/actioncable", to: "actioncable.esm.js"
pin_all_from "app/javascript/channels", under: "channels"



pin "navbar", to: "custom/navbar.js"
pin "carousel", to: "custom/carousel.js"
pin "profile_edit_form", to: "custom/profile_edit_form.js"
