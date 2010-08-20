$(document).ready(function(){
      $("#clickable-image").click( function( eventObj ) {
				var location = $("#clickable-image").elementlocation();
				var x = eventObj.pageX - location.x;
				var y = eventObj.pageY - location.y;

				var m = document.getElementById('marker');

        m.style.left = x +'px';
        m.style.top = y +'px';
        m.style.visibility = 'visible';

        var l = document.getElementById('form');
        l.style.visibility = 'visible';
      });
      $("#cmdSubmit").click( function( eventObj ) {

				var location = $("#marker").elementlocation();

        var x = location.x;
        var y = location.y;

        if ($('#diagnostic').val() != '' && x != -5 && y != -5)
				{
				      $.post('<?php echo $rootdir ?>/forms/body/save.php', { x: x, y: y, diagnostic: $('#diagnostic').val(), notes: $('#notes').val() },function(data){
				        window.location = "<?php echo $rootdir ?>/patient_file/encounter/load_form.php?formname=body";
            });
        }else{
          alert('Debe escribir un codigo y tener senalada una area.');
        }
      })
    });