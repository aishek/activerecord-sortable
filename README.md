[![Build Status](https://travis-ci.org/aishek/activerecord-sortable.png)](https://travis-ci.org/aishek/activerecord-sortable)
[![Code Climate](https://codeclimate.com/github/aishek/activerecord-sortable.png)](https://codeclimate.com/github/aishek/activerecord-sortable)
[![Coverage Status](https://coveralls.io/repos/aishek/activerecord-sortable/badge.png)](https://coveralls.io/r/aishek/activerecord-sortable)
[![Dependency Status](https://gemnasium.com/aishek/activerecord-sortable.png)](https://gemnasium.com/aishek/activerecord-sortable)
[![Gem Version](https://badge.fury.io/rb/activerecord-sortable.png)](http://badge.fury.io/rb/activerecord-sortable)

activerecord-sortable
====================

[README на русском языке](https://github.com/aishek/activerecord-sortable/blob/master/README.ru.md)

The gem allows you to integrate [jQuery UI Sortable](http://jqueryui.com/sortable/#default) with your models in Ruby on Rails app: for example, you'll be able to create admin page to arrange some items using drag and drop.

## How it works

* Order kept using values of integer column, `position` by default.
* To retreive instances in order, auto created scope, `ordered_by_position_asc` by default.
* All integer column values shifted for affected records on destroy some other record.
* Auto created `move_to!`, wich allows to move instance to specified position.
* Any position column changes affects `updated_at` and `updated_on` column values.
* Gem includes jQuery-plugin to easily integrate drag and drop with `move_to!` (see example below).

## Example

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

```html
<!-- app/views/things/index.html.erb -->

<h1>Sortable thing</h1>

<p>Use drag and drop to sort things, reload page, notice order kept.</p>

<ol data-role="activerecord_sortable">
  <%= render @things %>
</ol>
```

```html
<!-- app/views/things/_thing.html.erb -->

<!-- required attributes are data-role, data-move-url, data-position -->
<li data-role="thing<%= thing.id %>" data-move-url="<%= move_thing_url(thing) %>" data-position="<%= thing.position %>">
  <h2>Thing <%= thing.id %></h2>
</li>
```

```js
// app/views/things/move.js.er

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

See also [dummy app code](https://github.com/aishek/activerecord-sortable/tree/master/spec/dummy).

## Settings
```ruby
class Thing < ActiveRecord::Base
  acts_as_sortable do |config|
    # which relation use to keep instances in order
    # this setting is useful in STI models case
    # using all instances of model by default
    config[:relation] = ->(instance) {instance.class}

    # append new instances to relation on create
    # prepend by default
    config[:append] = false

    # integer column to specify order
    # position by default
    config[:position_column] = :position
  end
end
```

## JavaScript Events

Is example:

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

`$('*[data-role=activerecord_sortable]')` triggers events:

* `sortable:start` – change position ajax request sended to server
* `sortable:stop` – server respond to ajax request
* `sortable:sort_success` – server respond successfully to change position ajax request
* `sortable:sort_error` – server respond with error to change position ajax request

Before send ajax request to server jQuery UI Sortable disabled, after receive response enable.

## How to add activerecord-sortable into existing model

```ruby
# Gemfile

gem 'activerecord-sortable'
```

```ruby
# db/migrate/20140525112125_add_position_to_items.rb

class AddPositionToItems < ActiveRecord::Migration
  def change
    add_column :items, :position, :integer

    # specify order
    Item.order('id desc').each.with_index do |item, position|
      item.update_attribute :position, position
    end

    change_column :items, :position, :integer, :null => false

    add_index :items, [:position]
  end
end
```

```ruby
# app/models/item.rb

class Item < ActiveRecord::Base
  acts_as_sortable
end

```

## Note on Patches / Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Send me a pull request. Bonus points for topic branches.

## License

activerecord-sortable is free software, and may be redistributed under the terms specified in the LICENSE file.

## Credits

Gem activerecord-sortable is maintained by [Cifronomika](http://cifronomika.ru/).

Contributors:

* [Alexandr Borisov](https://github.com/aishek)
* [Kirill Khrapkov](https://github.com/cubbiu)
