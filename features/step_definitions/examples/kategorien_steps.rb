# encoding: utf-8

Dann /^man sieht das Register Kategorien$/ do
  find("nav a[href*='categories']", text: _("Categories"))
  sleep(0.33)
end

Wenn /^man das Register Kategorien wählt$/ do
  find("nav a[href*='categories']").click
  find("#categories-index-view h1", text: _("List of Categories"))
end

Und /^man eine neue Kategorie erstellt$/ do
  find("a", text: _("New Category")).click
end

Und /^man gibt den Namen der Kategorie ein$/ do
  @new_category_name = "Neue Kategorie"
  find("input[name='category[name]']").set @new_category_name
end

Und /^man gibt die Elternelemente und die dazugehörigen Bezeichnungen ein$/ do
  @parent_category = ModelGroup.where(name: "Portabel").first
  @label_1 = "Label 1"
  find("#categories input[data-type='autocomplete']").set @parent_category.name
  find("a.ui-corner-all", match: :first, text: @parent_category.name).click
  find("#categories .list-of-lines .line", text: @parent_category.name).find("input[type='text']").set @label_1
end

Dann /^ist die Kategorie mit dem angegegebenen Namen erstellt$/ do
  find("#categories-index-view h1", text: _("List of Categories"))
  expect(current_path).to eq manage_categories_path(@current_inventory_pool)
  expect(ModelGroup.where(name: "#{@new_category_name}").count).to eq 1
end

Dann /^ist die Kategorie mit dem angegegebenen Namen und den zugewiesenen Elternelementen( und dem Bild)? erstellt$/ do |image|
  find("#categories-index-view h1", text: _("List of Categories"))
  expect(current_path).to eq manage_categories_path(@current_inventory_pool)
  @category = Category.find_by_name "#{@new_category_name}"
  expect(@category).not_to be_nil
  expect(ModelGroupLink.where("ancestor_id = ? AND label = ?", @parent_category.id, @label_1).count).to eq 1
  if image
    expect(@category.images.count).to eq 1
  end
end

Dann /^sieht man die Liste der Kategorien$/ do
  within("#categories-index-view") do
    find("h1", text: _("List of Categories"))
    expect(current_path).to eq manage_categories_path(@current_inventory_pool)
    @parent_categories = ModelGroup.where(type: "Category").select { |mg| ModelGroupLink.where(descendant_id: mg.id).empty? }
    @parent_categories.each do |pc|
      find ".line", visible: true, text: pc.name
    end
  end
end

Wenn /^man eine Kategorie editiert$/ do
  visit manage_categories_path @current_inventory_pool
  @category = ModelGroup.where(name: "Portabel").first
  within("#categories-index-view #list") do
    find(".line", match: :first)
    all(".button[data-type='expander'] i.arrow.right").each {|toggle| toggle.click }
    find("a[href='/manage/%d/categories/%d/edit']" % [@current_inventory_pool.id, @category.id], match: :first).click
  end
end

Wenn /^man den Namen und die Elternelemente anpasst$/ do
  @new_category_name = "Neue Kategorie"
  find("input[name='category[name]']").set @new_category_name

  expect(@category.parents.count).to eq 2

  within("#categories .list-of-lines") do
    @parent_category_labels = @category.parents.map do |parent|
      new_label = "Label #{parent.name}"
      find(".line", match: :prefer_exact, text: parent.name).find(".col3of10 input").set new_label
      new_label
    end
  end
end

Dann /^werden die Werte gespeichert$/ do
  find("#categories-index-view h1", text: _("List of Categories"))
  expect(current_path).to eq manage_categories_path(@current_inventory_pool)
  @category.reload
  expect(@category.name).to eq @new_category_name
  expect(@category.links_as_child.count).to eq 2
  expect(@category.links_as_child.map(&:label).to_set).to eq @parent_category_labels.to_set
end

Und /^die Kategorien sind alphabetisch sortiert$/ do
  sorted_parent_categories = @parent_categories.sort
  @first_category = sorted_parent_categories.first
  @last_category = sorted_parent_categories.last
  @visible_categories = all("#categories-index-view .line", visible: true)
  @visible_categories.first.text.include? @first_category.name
  @visible_categories.last.text.include? @last_category.name
end

Und /^die erste Ebene steht zuoberst$/ do
  expect(@visible_categories.count).to eq @parent_categories.count
end

Und /^man kann die Unterkategorien anzeigen und verstecken$/ do
  child_name = @first_category.children.first.name
  within @visible_categories.first do
    find(".button[data-type='expander'] i.arrow.right").click
    find(".button[data-type='expander'] i.arrow.down")
  end
  find(".group-of-lines .line .col3of9:nth-child(2) strong", visible: true, text: child_name)
  within @visible_categories.first do
    find(".button[data-type='expander'] i.arrow.down").click
    find(".button[data-type='expander'] i.arrow.right")
  end
  expect(has_no_selector?(".group-of-lines .line .col3of9:nth-child(2) strong", visible: true, text: child_name)).to be true
end

Wenn /^man das Modell editiert$/ do
  @model = Model.find {|m| [m.name, m.product].include? "Sharp Beamer" }
  step 'ich nach "%s" suche' % @model.name
  sleep(0.11)
  find(".line", text: @model.name, match: :prefer_exact).find(".button", :text => _("Edit %s" % "Model")).click
end

Wenn /^ich die Kategorien zuteile$/ do
  @category = ModelGroup.where(name: "Standard").first
  find("#categories input[data-type='autocomplete']").set @category.name
  sleep(0.11)
  find("a.ui-corner-all", match: :first, text: @category.name).click
  find("#categories .list-of-lines .line", text: @category.name)
end

Wenn /^ich das Modell speichere$/ do
  click_button _("Save %s") % _("Model")
  find("h1", text: _("List of Inventory"))
  find("#flash .success")
end

Dann /^sind die Kategorien zugeteilt$/ do
  sleep(0.33) # fix lazy request problem
  expect(@model.model_groups.where(id: @category.id).count).to eq 1
end

Wenn /^ich eine oder mehrere Kategorien entferne$/ do
  within("#categories .list-of-lines") do
    @model.categories.each do |category|
      find(".line", text: category.name).find(".button[data-remove]", text: _("Remove")).click
    end
  end
end

Dann /^sind die Kategorien entfernt und das Modell gespeichert$/ do
  expect(has_content?(_("List of Inventory"))).to be true
  expect(@model.categories.reload.empty?).to be true
end

Wenn /^eine Kategorie nicht genutzt ist$/ do
  @unused_category = Category.all.detect{|c| c.children.empty? and c.models.empty?}
end

Wenn /^man die Kategorie löscht$/ do
  visit manage_categories_path @current_inventory_pool
  within("#categories-index-view #list") do
    find(".line", match: :first)
    all(".button[data-type='expander'] i.arrow.right").each {|toggle| toggle.click }
    within(".line[data-id='#{@unused_category.id}']", match: :first) do
      find(".multibutton .dropdown-holder .dropdown-toggle").click
      find(".multibutton .dropdown-item.red[data-method='delete']", text: _("Delete")).click
    end
  end
end

Dann /^ist die Kategorie gelöscht und alle Duplikate sind aus dem Baum entfernt$/ do
  sleep(0.33)
  expect(all("#categories-index-view .line[data-id='#{@unused_category.id}']").empty?).to be true
  expect { @unused_category.reload }.to raise_error
end

Dann /^man bleibt in der Liste der Kategorien$/ do
  find("#categories-index-view h1", text: _("List of Categories"))
  expect(current_path).to eq manage_categories_path(@current_inventory_pool)
end

Wenn /^eine Kategorie genutzt ist$/ do
  @used_category = Category.all.detect{|c| not c.children.empty? or not c.models.empty?}
end

Dann /^ist es nicht möglich die Kategorie zu löschen$/ do
  visit manage_categories_path @current_inventory_pool
  within("#categories-index-view #list") do
    within(".line[data-id='#{@used_category.id}']") do
      expect(all(".multibutton .dropdown-holder .dropdown-toggle").size).to eq 0
      expect(all(".multibutton .dropdown-item.red[data-method='delete']", text: _("Delete")).size).to eq 0
    end
  end
end

Wenn /^ich eine ungenutzte Kategorie lösche die im Baum mehrmals vorhanden ist$/ do
  @unused_category = Category.all.detect{|x| x.models.count == 0 and x.children.count == 0 and x.parents.count > 1}
  step 'man die Kategorie löscht'
end

Wenn /^man nach einer Kategorie anhand des Namens sucht$/ do
  visit manage_categories_path @current_inventory_pool
  @searchTerm ||= Category.first.name[0]
  countBefore = all(".line").size
  find("#list-search").set @searchTerm
  find("#list-search")
  find(".line", match: :first)
  expect(countBefore).not_to eq all(".line").size
  sleep(0.33)
end

Dann /^sieht man nur die Kategorien, die den Suchbegriff im Namen enthalten$/ do
  all("#categories-index-view .line", :visible => true).each do |line|
    expect(line.text).to match(Regexp.new(@searchTerm, "i"))
  end
end

Dann /^sieht die Ergebnisse in alphabetischer Reihenfolge$/ do
  names = all(".category_name", :visible => true).map{|name| name.text}
  expect(names.sort == names).to be true
end

Dann /^man kann diese Kategorien editieren$/ do
  all("#categories-index-view .line", :visible => true).each do |line|
    line.find("a[href*='categories'][href*='edit']")
  end
end

Wenn /^man nach einer ungenutzten Kategorie anhand des Namens sucht$/ do
  @unused_category = Category.all.detect{|c| c.children.empty? and c.models.empty?}
  @searchTerm = @unused_category.name
  step 'man nach einer Kategorie anhand des Namens sucht'
end

Dann /^man kann diese Kategorien löschen$/ do
  within(".line[data-id='#{@unused_category.id}']", match: :first) do
    find(".multibutton .dropdown-holder .dropdown-toggle").click
    find(".multibutton .dropdown-item.red[data-method='delete']", text: _("Delete"))
  end
end

When(/^I add an image$/) do
  find("input[type='file']", match: :first, visible: false)
  page.execute_script("$('input:file').attr('class', 'visible');")
  image_field_id = find(".visible", match: :first)
  image_field_id.set Rails.root.join("features", "data", "images", "image1.jpg")
end

Then(/^I can not add a second image$/) do
  find("#images [data-type='select']").click
  alert = page.driver.browser.switch_to.alert
  expect(alert.text).to eq _("Category can have only one image.")
  alert.accept
  expect(all("#images .line").count).to eq 1
end

Given(/^there exists a category with an image$/) do
  @category = Category.find {|c| c.images.exists?}
  expect(@category).not_to be_nil
end

When(/^I remove the image$/) do
  find(".row.emboss", text: _('Image')).find("[data-type='inline-entry'] button[data-remove]").click
end

Given(/^one edits this category$/) do
  visit manage_edit_category_path(@current_inventory_pool, @category)
end

When(/^I add a new image$/) do
  find("input[type='file']", match: :first, visible: false)
  page.execute_script("$('input:file').attr('class', 'visible');")
  image_field_id = find(".visible", match: :first)
  @filename = "image2.jpg"
  image_field_id.set Rails.root.join("features", "data", "images", @filename)
end

Then(/^the category was saved with the new image$/) do
  find("#categories-index-view h1", text: _("List of Categories"))
  expect(current_path).to eq manage_categories_path(@current_inventory_pool)
  images = @category.images
  expect(images.count).to eq 1
  image = images.first
  expect(image.filename).to eq @filename
end
