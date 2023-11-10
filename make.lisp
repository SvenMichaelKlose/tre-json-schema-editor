(= *modules-path* "/home/pixel/Desktop/git/tre/tre/modules/")

(load (+ *modules-path* "/js/make-js-project.lisp"))

(make-js-project
  :title
    "JSON Schema editor"
  :outfile
    "docker/www/index.html"
  :internal-stylesheet
    (fetch-file "style.css")
  :files
    '("main.lisp"))

(quit)
