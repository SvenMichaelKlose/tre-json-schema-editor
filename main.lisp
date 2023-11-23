(const *json-schema-basic-types* '("string" "object" "number" "array" "boolean"))
(defclass  (json-schema-title lml-component) (init-attrs)
  (super init-attrs)
  (set-state (merge {"is_editing" nil} init-attrs))
  this)

(defmethod  json-schema-title render ()
  (!= props.schema.title
    ($$ (? state.is_editing
           `(input :grab-focus  t
                   :on-blur     ,[set-state {is_editing nil}]
                   :value       ,(| ! ""))
           `(span :on-click ,[set-state {is_editing t}]
              ,(? state.is_editing
                  (+ "(" ! ")")
                  "(no title)"))))))

(finalize-class json-schema-title)
(declare-lml-component json-schema-title)

(fn json-schema-type (attrs)
  (!= attrs.schema
    ($$ `(div ,(+ !.type " ") (json-schema-title :schema ,!)))))

(declare-lml-component json-schema-type)


(defclass (json-schema-object lml-component) (init-attrs)
  (super init-attrs)
  (replace-state init-attrs)
  this)

(defmethod json-schema-object add (e)
  (!= ($? "<.json-add" e.target)
    (= (ref state.schema.properties ($? "input" !).value) ($? "select" !).value)
    (replace-state state)))

(defmethod json-schema-object render ()
  (!= state.schema
    ($$ `(table
           (tr (th :class "json-schema-typename" :colspan 2 "object " (json-schema-title :schema ,!)))
           ,@(maphash #'((k v)  ; TODO: Enable @ to process hash tables and objects.
                          `(tr
                             (td ,(+ k ":"))
                             (td (json-schema :schema ,v))))
                      !.properties)
           (tr :class "json-add"
             (td (input :type "text"))
             (td
               (select ,@(@ [`(option :value ,_ ,_)]
                            *json-schema-basic-types*))
               (button "+" :on-click ,[add _])))))))

(finalize-class json-schema-object)
(declare-lml-component json-schema-object)


(fn expand-type (props)
  (? (string? props)
     {"type" props}
     props))

(fn json-schema (attrs)
  (!= (expand-type attrs.schema)
    ($$ `(,(? (string== "object" !.type)
             'json-schema-object
             'json-schema-type)
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
        "age"       "number"
        "is_member" "boolean"
        "guests"    "array"
    }
})

(document.body.add ($$ `(json-schema :schema ,*schema*)))
(document.body.add-event-listener "DOMNodeInserted"
  [($* "[grabfocus]").map [(_.focus)]] nil)
