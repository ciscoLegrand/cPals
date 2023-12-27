# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "canvas-confetti", to: "https://ga.jspm.io/npm:canvas-confetti@1.9.2/dist/confetti.module.mjs"
pin "highlight.js", to: "https://ga.jspm.io/npm:highlight.js@11.9.0/es/index.js"
