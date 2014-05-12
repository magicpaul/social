module QuizzesHelper
    def get_badge(score)
        case
            when score > 75
                return "gold"
            when score > 50
                return "silver"
            else
                return "bronze"
        end
    end
    def link_to_add_fields(name, f, association)
        new_object = f.object.send(association).klass.new
        id = new_object.object_id
        fields = f.fields_for(association, new_object, child_index: id) do |builder|
          render(association.to_s.singularize + "_fields", f: builder)
        end
        link_to(name, '#', class: "add_fields tiny button", data: {id: id, fields: fields.gsub("\n", "")})
    end
end
