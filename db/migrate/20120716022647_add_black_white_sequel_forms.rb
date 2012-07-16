class AddBlackWhiteSequelForms < ActiveRecord::Migration

  @@genie_names = ['Landorus', 'Thundurus', 'Tornadus']
  @@kyurem_forms = ['Black', 'White']
  
  def up
    add_index :pokemon, [:name, :form_name], :unique => true

    keldeo = Pokemon.find_by_name('Keldeo')

    Pokemon.create(
      :dex_number => keldeo.dex_number,
      :name => keldeo.name,
      :form_name => 'Resolution',
      :form_order => 1
    )

    genies = Pokemon.where('name IN (?)', @@genie_names)
    genies.each do |genie|
      genie.form_name = 'Incarnate'
      genie.save

      Pokemon.create(
        :dex_number => genie.dex_number,
        :name => genie.name,
        :form_name => 'Therian',
        :form_order => 1
      )
    end

    kyurem = Pokemon.find_by_name('Kyurem')
    kyurem.form_order = 0
    kyurem.save

    @@kyurem_forms.each do |form|
      Pokemon.create(
        :dex_number => kyurem.dex_number,
        :name => kyurem.name,
        :form_name => form,
        :form_order => 1
      )
  end
  end

  def down
    @@kyurem_forms.each do |form|
      Pokemon.find_by_name_and_form_name('Kyurem', form).destroy
    end

    Pokemon.where('name IN (?) AND form_name = ?', @@genie_names, 'Therian').destroy_all
    Pokemon.where('name IN (?)', @@genie_names).update_all(:form_name => nil)

    Pokemon.find_by_name_and_form_name('Keldeo', 'Resolution').destroy

    remove_index :pokemon, :column => [:name, :form_name]
  end
end
