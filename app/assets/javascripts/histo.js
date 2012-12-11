var draw_histo = function(json_data){

  $('#histo').text('');

  var bartimes = json_data.response_times;

  var nbins = 17;
  var binned = [];
  for(var i=0;i<nbins;i++){binned.push(0);}
  var maxtime = 14400;
  var binwidth = maxtime / nbins;
  var binnames = [];
  for(var i=0;i<nbins;i++){binnames.push(Math.round(i*binwidth/360)/10 + "-" +
                                         (Math.round((i+1)*binwidth/360))/10);}
  bartimes.forEach(function(d){ binned[ Math.floor(d/binwidth) ]+=1 });
  var maxcount = 0;
  binned.forEach(function(d){d > maxcount ? maxcount = d : null;});

  var width = $('#histo').width(),
      height = width;

  var barsvg = d3.select("#histo").append("svg")
      .attr("width", width)
      .attr("height", height)
    .append("g")
      .attr("class", "barchart");

  var barcolor = d3.interpolateHsl("#00f", "#f00");


  var b = barsvg.selectAll(".bar")
      .data(binned)
    .enter().append("g")
      .attr("class", "bar");

  var em_px = $("#histo").css('font-size').split("px")[0];

  var scaling = (width - 7*em_px) / maxcount;

  b.append("rect")
      .attr("x", function(d,i){return "6em";})
      .attr("y", function(d,i){return 1.2 * em_px * (i + 1);})
      .attr("height", "1em")
      .attr("width", function(d,i){return scaling * d;})
      .style("fill", function(d, i) { return barcolor(i/nbins); });

  var l = barsvg.selectAll(".barlegend")
      .data(binnames)
    .enter().append("g")
      .attr("class", "barlegend");

  l.append("text")
      .attr("x", "5em")
      .attr("y", function(d,i){return 1.2 * em_px * (i + 1) + 0.75 * em_px;})
      .text(function(d){return d;})
};
