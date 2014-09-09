# -*- encoding : utf-8 -*-

Angenommen(/^man befindet sich auf der Seite der Hauptkategorien$/) do
  visit borrow_root_path
end

Dann(/^sieht man genau die für den User bestimmte Haupt\-Kategorien mit Namen$/) do
  @main_categories = @current_user.all_categories.select {|c| c.parents.empty?}
  categories_counter = 0
  @main_categories.each do |mc|
    find("a", match: :first, text: mc.name)
    categories_counter += 1
  end
  expect(categories_counter).to eq @main_categories.count
end

Wenn(/^man eine Hauptkategorie auswählt$/) do
  @main_category = (@current_user.all_categories & Category.roots).sample
  find("[data-category_id='#{@main_category.id}'] a", match: :first).click
end

Und(/^man sieht die Überschrift "(.*?)"$/) do |arg1|
  find ".row a", text: _("Start")
end

Wenn(/^ich über eine Hauptkategorie mit Kindern fahre$/) do
  @main_category = (@current_user.all_categories & Category.roots).find do |c|
    borrowable_children = (Category.with_borrowable_models_for_user(@current_user) & c.children)
    c.children.size != borrowable_children.size and borrowable_children.size > 0
  end
  page.execute_script %Q{$('*[data-category_id] .padding-inset-s:contains("#{@main_category.name}")').trigger('mouseenter')}
  page.execute_script %Q{$('*[data-category_id] .padding-inset-s:contains("#{@main_category.name}")').closest('*[data-category_id]').find('.dropdown').show()}
end

Dann(/^sehe ich nur die Kinder dieser Hauptkategorie, die dem User zur Verfügung stehende Gegenstände enthalten$/) do
  second_level_categories = @main_category.children
  visible_2nd_level_categories = (Category.with_borrowable_models_for_user(@current_user) & @main_category.children)
  @second_level_category = visible_2nd_level_categories.first
  find("a", match: :first, text: @second_level_category.name)

  visible_2nd_level_categories_count = 0
  within find("[data-category_id] .padding-inset-s", match: :first, text: @main_category.name).first(:xpath, "../..").find(".dropdown-holder", match: :first) do
    visible_2nd_level_categories.each do |c|
      find(".dropdown a", match: :first, text: c.name)
      visible_2nd_level_categories_count += 1
    end
  end
  expect(visible_2nd_level_categories_count).to eq visible_2nd_level_categories.size
end

Wenn(/^ich eines dieser Kinder anwähle$/) do
  click_link @second_level_category.name
end

Dann(/^lande ich in der Modellliste für diese Hauptkategorie$/) do
  expect((Rack::Utils.parse_nested_query URI.parse(current_url).query)["category_id"].to_i).to eq @main_category.id
end

Dann(/^lande ich in der Modellliste für diese Kategorie$/) do
  expect((Rack::Utils.parse_nested_query URI.parse(current_url).query)["category_id"].to_i).to eq @second_level_category.id
end

Angenommen(/^es gibt eine Hauptkategorie, derer Kinderkategorien keine dem User zur Verfügung stehende Gegenstände enthalten$/) do
  @main_category = (@current_user.all_categories & Category.roots).find do |c|
    (Category.with_borrowable_models_for_user(@current_user) & c.children).size == 0
  end
end

Dann(/^hat diese Hauptkategorie keine Kinderkategorie\-Dropdown$/) do
  expect(find(".row.emboss.focus-hover", match: :first, text: @main_category.name).has_no_selector? ".dropdown-holder").to be true
end

Then(/^one sees for each category its image, or if not set, the first image of a model from this category$/) do
  @main_categories.each do |mc|
    img_el = find("a", match: :first, text: mc.name).find("img")
    response = get img_el[:src]
    if image = mc.image
      expect(response.location).to match /#{image.public_filename}/
    end
  end
end

Given(/^there exists a main category with own image$/) do
  (@current_user.all_categories & Category.roots).find do |c|
    expect(c.images.exists?).not_to be_nil
  end
end

Given(/^there exists a main category without own image but with a model with image$/) do
  expect((@current_user.all_categories & Category.roots).find do |c|
    not c.images.exists? and c.all_models.detect{|m| not m.image.blank? }
  end).not_to be_nil
end
