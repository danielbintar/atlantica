class Item
  include Mongoid::Document
  field :name,   type: String
  field :childs, type: Hash,    default: {}
  field :batch,  type: Integer, default: 0
  field :price,  type: Integer

  def cheapest_form(count)
    total_price = price * count

    if childs.empty?
      return [
        { "#{name}" => count },
        {},
        total_price
      ]
    end

    ba = (count + batch - 1) / batch
    ing = {}
    cre = {}
    chi_p = 0
    childs.each do |child_id, child_count|
      child = Item.find(child_id)
      f = child.cheapest_form(child_count.to_i * ba)
      f[0].each { |k, v| ing[k] = ing[k].to_i + v }
      f[1].each { |k, v| cre[k] = cre[k].to_i + v }
      chi_p += f[2]
    end

    # raise chi_p
    if chi_p > total_price
      return [
        { "#{name}" => count },
        {},
        total_price
      ]
    end

    cre[name] = ba * batch
    [ing, cre, chi_p]
  end
end
