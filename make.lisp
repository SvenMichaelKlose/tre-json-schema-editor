(= *modules-path* "/home/pixel/Desktop/git/tre/tre/modules/")
(load (+ *modules-path* "/js/make-js-project.lisp"))
(make-js-project
  :title    "JSON Schema editor"
  :outfile  "www/index.html"
  :files
    '("src/main.lisp"))
(quit)
