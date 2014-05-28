[![Build Status](https://travis-ci.org/aishek/activerecord-sortable.png)](https://travis-ci.org/aishek/activerecord-sortable)
[![Code Climate](https://codeclimate.com/github/aishek/activerecord-sortable.png)](https://codeclimate.com/github/aishek/activerecord-sortable)
[![Coverage Status](https://coveralls.io/repos/aishek/activerecord-sortable/badge.png)](https://coveralls.io/r/aishek/activerecord-sortable)
[![Dependency Status](https://gemnasium.com/aishek/activerecord-sortable.png)](https://gemnasium.com/aishek/activerecord-sortable)
[![Gem Version](https://badge.fury.io/rb/activerecord-sortable.png)](http://badge.fury.io/rb/activerecord-sortable)

activerecord-sortable
====================

Этот gem позволяет интегрировать [jQuery UI Sortable](http://jqueryui.com/sortable/#default) с моделями в Rails-приложении. Например, с помощью activerecord-sortable можно сделать страницу в системе управления для смены порядка товаров внутри категории перетаскиванием.

## Пример

```ruby
# Gemfile

gem 'activerecord-sortable'
```

```ruby
# app/models/thing.rb

class Thing < ActiveRecord::Base
  acts_as_sortable
end
```

```ruby
# db/migrate/20140512100816_create_things.rb

class CreateThings < ActiveRecord::Migration
  def change
    create_table :things do |t|
      t.integer :position, :null => false
      t.timestamps
    end

    add_index :things, [:position]
  end
end
```

```ruby
# app/controllers/things_controller.rb

class ThingsController < ApplicationController
  def index
    @things = Thing.ordered_by_position_asc
  end

  def move
    @thing = Thing.find(params[:id])
    @thing.move_to! params[:position]
  end
end

```

```ruby
<!-- app/views/things/index.html.erb -->

<h1>Sortable thing</h1>

<p>Use drag and drop to sort things, reload page, notice order kept.</p>

<ol data-role="activerecord_sortable">
  <%= render @things %>
</ol>
```

```ruby
<!-- app/views/things/_thing.html.erb -->

<li data-role="thing<%= thing.id %>" data-move-url="<%= move_thing_url(thing) %>" data-position="<%= thing.position %>">
  <h2>Thing <%= thing.id %></h2>
</li>
```

```ruby
<!-- app/views/things/move.js.erb -->

var node = $('*[data-role="thing<%= @thing.id %>"]');
var new_node_html = '<%= j render @thing %>';

node.replaceWith(new_node_html);
```

```js
// app/assets/javascripts/application.js

//= require jquery
//= require jquery_ujs
//= require sortable

//= require jquery.ui.sortable

$(document).ready(function(){
  $('*[data-role=activerecord_sortable]').activerecord_sortable();
});
```

Смотрите также [код тестового приложения](https://github.com/aishek/activerecord-sortable/tree/master/spec/dummy).

## Патчи и пулл-реквесты

* Сделайте форк.
* Внесите изменения.
* Сделайте пулл-реквест. Ваши изменения в отдельной ветке принесут плюс в карму :)

## Лицензия

activerecord-sortable является бесплатным ПО, подробности в файле [LICENSE](https://github.com/aishek/activerecord-sortable/LICENSE).

## Авторы

Плагин activerecord-sortable поддерживается [Цифрономикой](http://cifronomika.ru/).

Авторы:

* [Александр Борисов](https://github.com/aishek)
* Кирилл Храпков
