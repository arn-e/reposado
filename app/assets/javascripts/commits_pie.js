var draw_pie = function(json_data){

  d3.select("#pie").text("");

  if (typeof json_data.committers === 'undefined' || json_data.committers.length < 1 ||
      typeof json_data.committers[0].name === 'undefined' || json_data.committers[0].num === 'undefined') {
      $('#pie').append('<p class="pie_err">BORKEN</p>');
      return -1;
  } else {

    var width = $('#pie').width(),
        height = width,
        radius = 0.25 * height;

    /*from ColorBrewer*/
    var YlOrRd = ["rgb(255,255,204)", "rgb(255,237,160)",
                    "rgb(254,217,118)", "rgb(254,178,76)",
                    "rgb(253,141,60)",  "rgb(252,78,42)",
                    "rgb(227,26,28)",   "rgb(189,0,38)",
                    "rgb(128,0,38)"]

    var color = d3.scale.ordinal()
        .range(YlOrRd.reverse());

    var arc = d3.svg.arc()
        .outerRadius(radius)
        .innerRadius(0);

    var pie = d3.layout.pie()
        .sort(null)
        .value(function(d) { return d.num; });

    var pie_svg = d3.select("#pie").append("svg")
        .attr("class", "pie_svg")
        .attr("width", width)
        .attr("height", height);

    pie_svg.append("g")
            .attr("class", "arc_group")
            .attr("transform", "translate(" + radius + "," + height/2 + ")");

    pie_svg.append("g")
            .attr("class", "legend_group")
            .attr("transform", "translate(" + 2*radius + "," + height/2 + ")");

    var detail_popup = pie_svg.append("g")
            .attr("class", "detail_popup")
            .attr("transform", "translate(" + (2*radius) + "," + height/2 + ")")
            .append("text");

    var total_commits = 0;

    var show_user = function( d ){
            detail_popup.append("tspan")
                .attr("class", "popup_user")
                .attr("x", "1em")
                .attr("y", "-5em")
                .text(d.name);

            detail_popup.append("tspan")
                .attr("class", "popup_text")
                .attr("x", "1em").attr("y", "-3em")
                .text(Math.round(100 * d.num / total_commits) +
                    "% of total commits.");
    };

    var unshow_user = function(){
            detail_popup.text(null);
    };

    var light_sel = function( i ){
            d3.select(".arcno" + i).style("fill", "#dd6");
            d3.select(".legno" + i)
            .selectAll("circle")
            .style("fill", "#dd6");
    };

    var unlight_sel = function( i ){
            d3.select(".arcno" + i).style("fill", color(i));
            d3.select(".legno" + i)
            .selectAll("circle")
            .style("fill", color(i));
    };

    json_data.committers.sort( function(a,b) {return b.num - a.num;} );
    json_data.committers.forEach(function(d,i) { total_commits += d.num; d.ind = i; });

    var eight_and_others = json_data.committers.slice(0,8);
    if (json_data.committers.length > 8) {
        var rest_num = json_data.committers.slice(8).reduce(
                        function(sum,a){return sum + a.num;}, 0);
        eight_and_others.push( {"name" : "(others)", "num" : rest_num, "ind" : 8} );
    };

    var arc_group = pie_svg.select("g.arc_group")
        .selectAll("path.arc")
        .data(pie(eight_and_others))
        .enter().append("path")
        .attr("class", "arc");

    arc_group.attr("d", arc)
        .attr("class",   function(d) {return "arcno" + d.data.ind;} )
        .style("fill",   function(d) {return color(d.data.ind);})
        .on("mouseover", function(d) {show_user(d.data);
                                        light_sel(d.data.ind); })
        .on("mouseout",  function(d) {unshow_user();
                                        unlight_sel(d.data.ind); } );

    var legend_em_px = $('g.legend_group').css('font-size').split('px')[0];

    var legend_group = pie_svg.select("g.legend_group")
        .selectAll("g.legend_entry_group")
        .data(eight_and_others)
        .enter().append("g")
        .attr("class",     function(d) {return "legend_entry_group " + "legno" + d.ind;})
        .attr("transform", function(d) {return "translate(0," + legend_em_px * d.ind + ")";})
        .on("mouseover",   function(d) {show_user(d);
                                        light_sel(d.ind); })
        .on("mouseout",    function(d) {unshow_user();
                                        unlight_sel(d.ind); } );

    legend_group.append("text")
        .attr("x", 3 * legend_em_px)
        .style("text-anchor", "end")
        .text(function(d){return d.num;});

    legend_group.append("circle")
        .attr("cx", 4 * legend_em_px)
        .attr("cy", -legend_em_px/2.5)
        .attr("r", legend_em_px/2)
        .style("fill", function(d) {return color(d.ind);} );

    legend_group.append("text")
        .text(function(d){return d.name;})
        .attr("x", "5em");
  };
};
