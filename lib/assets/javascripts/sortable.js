(function(window, $){
  if(!$){throw new Error('jQuery required by Sortable')};


  function PositionsUpdater(node, new_position, old_position) {
    this.node = node;
    this.new_position = new_position;
    this.old_position = old_position;
  };

  PositionsUpdater.prototype.update = function() {
    var step = this.new_position > this.old_position ? -1 : 1;
    var start_position = step === -1 ? this.old_position + 1 : this.new_position;
    var stop_position = step === -1 ? this.new_position : this.old_position - 1;
    var target, data_position;

    $('*[data-position]', this.node)
      .filter(function(){
        var position = $(this).data('position');
        return position >= start_position && position <= stop_position;
      })
      .each(function(){
        var target = $(this);

        var data_position = target.data('position');
        var new_position = data_position + step;

        target.attr('data-position', new_position).data('position', new_position);
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


  function Sortable(node) {
    this.node = node;

    this.node.sortable({
      axis: 'y',
      stop: $.proxy(this.sortable_stop_handler, this)
    });
  };

  Sortable.prototype.sortable_stop_handler = function(e, ui) {
    this.node.sortable('disable').trigger('sortable:start');

    var node = ui.item;
    var new_position = node.index();
    var old_position = parseInt(node.data('position'));

    if (new_position === old_position) {
      this.node.sortable('enable');
    }
    else {
      var positions_updater = new PositionsUpdater(this.node, new_position, old_position);

      server_sorter = new ServerSorter(this.node, node, new_position, positions_updater);
      server_sorter.sort();
    }
  };


  $.fn.activerecord_sortable = function() {
    var target = $(this);
    target.each(function(){
      var self = $(this);
      var sortable_instance = new Sortable(self);

      self.data('sortable-instance', sortable_instance);
    });
  }
})(window, window.jQuery);
