<!doctype HTML>

<html>
<h2>
    Number GO
</h2>
<contents>
    Guessing handwritten digit
<table>
    <tr>
        <td style="border-style: none;">
            <div style="border: solid 2px #666; width: 143px; height: 144px;">
            <canvas width="140" height="140"></canvas>
            </div>
        </td>
    </tr>
    <tr>
        <td style="border-style: none;">
        <button id="bt_upload">Predict</button>
        <button onclick="show_bytes()">Show</button>
        <button onclick="clear_value()">Clear</button>
        </td>
    </tr>
    <tr>
        <td id="result">

        </td>
    </tr>
</table>
</contents>

</html>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script type="text/Javascript">
    $(document).ready(function() {
       $("#bt_upload").click(function() {
          canvas_data = escape(pixels);
          $.ajax({
             type: "POST",
             url: "http://127.0.0.1:5000/mnist",
             data: { "handwritten" : canvas_data }
          }).done(function(msg){
             res = msg.split("|")
             msg = "Predicted number is " + res[0] + " with probability of " + res[1] + "%";
             $("#result").html(msg);
          });
       });
    });
    var pixels = [];
    for (var i = 0; i < 28*28; i++) pixels[i] = 0
    var click = 0;
    var canvas = document.querySelector("canvas");
    var result = ""
    canvas.addEventListener("mousemove", function(e){
        if (e.buttons == 1) {
            click = 1;
            canvas.getContext("2d").fillStyle = "rgb(0,0,0)";
            canvas.getContext("2d").fillRect(e.offsetX, e.offsetY, 8, 8);
            x = Math.floor(e.offsetY * 0.2)
            y = Math.floor(e.offsetX * 0.2) + 1
            for (var dy = 0; dy < 2; dy++){
                for (var dx = 0; dx < 2; dx++){
                    if ((x + dx < 28) && (y + dy < 28)){
                        pixels[(y+dy)+(x+dx)*28] = 1
                    }
                }
            }
        } else {
            if (click == 1) set_value()
            click = 0;
        }
    });
    function show_bytes() {
      var textArea = document.getElementById("contents");
      textArea.innerHTML = pixels;
    }
    function set_value(){
        var result = ""
        for (var i = 0; i < 28*28; i++) result += pixels[i] + ","
    }
    function clear_value(){
        canvas.getContext("2d").fillStyle = "rgb(255,255,255)";
        canvas.getContext("2d").fillRect(0, 0, 140, 140);
        for (var i = 0; i < 28*28; i++) pixels[i] = 0
        $("#result").html("");
    }
</script>