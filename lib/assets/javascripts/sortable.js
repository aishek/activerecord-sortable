(function(window, $){
  if(!$){throw new Error('jQuery required by Sortable')};


  function PositionsUpdater(node, current_node, new_position, old_position) {
    this.node = node;
    this.current_node = current_node;
    this.new_position = new_position;
    this.old_position = old_position;
  };

  PositionsUpdater.prototype.update = function() {
    var step = this.new_position > this.old_position ? -1 : 1;
    var start_position = step === -1 ? this.old_position + 1 : this.new_position;
    var stop_position = step === -1 ? this.new_position : this.old_position - 1;
    var target, data_position;
    var current_node_role = this.current_node.data('role');

    $('*[data-position]', this.node)
      .filter(function(){
        var position = $(this).data('position');
        var role = $(this).data('role');

        return (current_node_role !== role) && position >= start_position && position <= stop_position;
      })
      .each(function(){
        var target = $(this);

        var data_position = target.data('position');
        var new_position = data_position + step;

        target.attr('data-position', new_position).data('position', new_position);

        var position_input_node = $('*[data-role~="position"]', target);
        if ( position_input_node.length > 0 ) {
          position_input_node.val(new_position);
        }
      });
  };


  function ServerSorter(node, current_node, new_position, positions_updater) {
    this.node = node;
    this.current_node = current_node;
    this.new_position = new_position;
    this.positions_updater = positions_updater;
  };

  ServerSorter.prototype.sort = function() {
    $.ajax({
      type: 'POST',
      dataType: 'script',
      url: this.current_node.data('move-url'),
      data: {
        position: this.new_position
      },
      success: $.proxy(this.sort_by_server_success, this),
      error: $.proxy(this.sort_by_server_error, this)
    });
  };

  ServerSorter.prototype.sort_by_server_success = function() {
    this.positions_updater.update();
    this.node.trigger('sortable:sort_success').trigger('sortable:stop').sortable('enable');
  };

  ServerSorter.prototype.sort_by_server_error = function() {
    this.node.sortable('cancel').trigger('sortable:sort_error').trigger('sortable:stop').sortable('enable');
  };


  function ClientSorter(node, current_node, new_position, positions_updater) {
    this.node = node;
    this.current_node = current_node;
    this.new_position = new_position;
    this.positions_updater = positions_updater;
  };

  ClientSorter.prototype.sort = function() {
    var position_input_node = $('*[data-role~="position"]', this.current_node);
    if ( position_input_node.length > 0 ) {
      this.positions_updater.update();

      this.current_node.data('position', this.new_position);
      position_input_node.val(this.new_position);
    }
    else {
      console && console.error && console.error('Could not found any *[data-role~="position"] element for', this.current_node);
    }
    this.node.trigger('sortable:sort_success').trigger('sortable:stop').sortable('enable');
  };


  function Sortable(node, options) {
    this.node = node;

    if (!options) options = {};
    options['update'] = $.proxy(this.sortable_stop_handler, this);

    var defaults = { axis: 'y' };
    var settings = $.extend({}, defaults, options);

    this.node.sortable(settings);
  };

  Sortable.prototype.sortable_stop_handler = function(e, ui) {
    this.node.sortable('disable').trigger('sortable:start');

    var node = ui.item;
    var new_position = node.index();
    var old_position = parseInt(node.data('position'));

    var positions_updater = new PositionsUpdater(this.node, node, new_position, old_position);

    var sorter_factory = (node.data('move-url') ? ServerSorter : ClientSorter);

    var sorter = new sorter_factory(this.node, node, new_position, positions_updater);
    sorter.sort();
  };


  $.fn.activerecord_sortable = function(options) {
    var target = $(this);
    target.each(function(){
      var self = $(this);
      var sortable_instance = new Sortable(self, options);

      self.data('sortable-instance', sortable_instance);
    });
  }
})(window, window.jQuery);
