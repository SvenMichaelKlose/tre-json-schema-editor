(const *json-schema-basic-types* '("string" "object" "number" "array" "boolean"))


(!= (new *mutation-observer
         #'((l o)
             (($* "[grabfocus]").map [(_.focus)])))
  (!.observe document.body {:child-list t :subtree t}))

(fn expand-type (props)
  (? (string? props)
     {:type props}
     props))


(defclass (json-schema-title lml-component) (init-attrs)
  (super init-attrs)
  (set-state {:is_editing nil})
  this)

(defmethod json-schema-title render ()
  (!= props.schema.title
    ($$ (? state.is_editing
           `(div (input :grab-focus  1
                   :on-blur     ,[set-state {:is_editing nil}]
                   :on-change   ,[props.parent.update "title" _.target.value]
                   :value       ,(| ! ""))
                 (button :on-click [$ (_.target).remove]
                   "X"))
           `(span :on-click ,[set-state {:is_editing t}]
              ,(+ "(" (| ! "no title") ")"))))))

(finalize-class json-schema-title)
(declare-lml-component json-schema-title)


(fn json-schema-type (attrs)
  (!= attrs.schema
    ($$ `(div ,!.type " " (json-schema-title :schema ,! :parent ,attrs.parent)))))

(declare-lml-component json-schema-type)


(defclass (json-schema-object lml-component) (init-attrs)
  (super init-attrs)
  this)

(defmethod json-schema-object update (key val)
  (set-state props)
  (= (ref state.schema.properties key) val)
  (state.parent.update key state.schema))

(defmethod json-schema-object add (e)
  (!= ($? "<.json-add" e.target)
    (set-state props)
    (= (ref state.schema.properties ($? "input" !).value) ($? "select" !).value)))

(defmethod json-schema-object render ()
  (!= props.schema
    ($$ `(table
           (tr
             (th :class    "json-schema-typename"
                 :colspan  2
               "object " (json-schema-title :schema ,! :parent ,this)))
           ,@(maphash #'((k v)
                          `(tr
                             (td ,(+ k ":"))
                             (td (json-schema :schema ,v :key ,k :parent ,this))))
                      !.properties)
           (tr :class "json-add"
             (td (input :type "text"))
             (td
               (select ,@(@ [`(option :value ,_ ,_)]
                            *json-schema-basic-types*))
               (button :on-click ,[add _] "+")))))))

(finalize-class json-schema-object)
(declare-lml-component json-schema-object)


(fn json-schema (attrs)
  (!= (expand-type attrs.schema)
    ($$ `(,(? (== "object" !.type)
              'json-schema-object
              'json-schema-type)
          :schema ,! :key ,attrs.key :parent ,attrs.parent))))

(declare-lml-component json-schema)


(defclass (json-schema-container lml-component) (init-attrs)
  (super init-attrs)
  this)

(defmethod json-schema-container update (dummy-key value)
  (set-state (new))
  (props.writer value))

(defmethod json-schema-container render ()
  ($$ `(json-schema :schema ,props.schema :parent ,this :key nil)))

(finalize-class json-schema-container)
(declare-lml-component json-schema-container)


(var *schema* {
    :type      "object"
    :title     "Test"
    :properties {
        :name  "string"
        :surname  {
            :type  "string"
        }
        :age       "number"
        :is_member "boolean"
        :guests    "array"
    }
})

(document.body.add ($$ `(json-schema-container
                          :schema ,*schema*
                          :writer ,[dump _ "Updated JSON"])))
