(fn json-schema-title (schema)
  (!? schema.title
      (+ "(" ! ")")
      "(no title)"))

(fn json-schema-string (props)
  (!= props.schema
    ($$ `(div ,(+ !.type " " (json-schema-title !))))))

(declare-lml-component json-schema-string)


(defclass (json-schema-object lml-component) (init-props)
  (super init-props)
  (replace-state props)
  this)

(defmethod json-schema-object add (e)
  (!= ($? "<.json-add" e.target)
    (= (ref state.schema.properties ($? "input" !).value) ($? "select" !).value)
    (replace-state state)))

(defmethod json-schema-object render ()
  (!= state.schema
    ($$ `(table
           (tr (th :class "json-schema-typename" :colspan 2 ,(json-schema-title !)))
           ,@(maphash #'((k v)  ; TODO: Enable @ to process hash tables and objects.
                          `(tr
                             (td ,(+ k ":"))
                             (td (json-schema :schema ,v))))
                      !.properties)
           (tr :class "json-add"
             (td (input :type "text"))
             (td
               (select ,@(@ [`(option :value ,_ ,_)]
                            '("string" "object")))
               (button "+" :on-click ,[add _])))))))

(finalize-class json-schema-object)
(declare-lml-component json-schema-object)


(fn json-schema-type-props (props)
  (? (string? props)
     {"type" props}
     props))

(fn json-schema (props)
  (!= (json-schema-type-props props.schema)
    ($$ `(,(case !.type
             "object"  'json-schema-object
             "string"  'json-schema-string
             (error "Unknown type ~A" !.type))
          :schema ,!))))

(declare-lml-component json-schema)


(var *schema* {
    "type"      "object"
    "title"     "Test"
    "properties" {
        "name"  "string"
        "surname"  {
            "type"  "string"
        }
    }
})

(document.body.add ($$ `(json-schema :schema ,*schema*)))
