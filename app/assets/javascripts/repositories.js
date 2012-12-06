function updateRepoStatus(repo_id) {
  $.getJSON('repositories/' + repo_id + '.json', function(repo) {
    if (repo.child_objects_loaded) {
      $('#loader-'+repo.id).css('display', 'none');
      $('#repo-link-'+repo.id).wrap('<a href="#" />');
      $('#repo-link-'+repo.id).parent().on('click', function(event) { showRepoInfo(repo); });
    } else {
      $('#loader-'+repo.id).css('display', 'inline');
      setTimeout(function(){ updateRepoStatus(repo_id) }, 5000); // try again in 5 secs
    }
  });
}

function showRepoInfo(repo) {
  $('#chart-repo-name').css('display', 'block');
  $('#chart-repo-name').html('<h1>' + repo.name + '</h1>');
  $('#chart-headers').css('display', 'block');
  var chart_data = $.parseJSON(repo.chart_data);
  draw_pie(chart_data);

  // add the words
  // loop over repo.chart_data.relevant_words
  var idx;
  var word;
  var score;
  for (idx=0; idx < chart_data.relevant_words.length; idx++) {
    word = chart_data.relevant_words[idx].word;
    score = chart_data.relevant_words[idx].score;
    $('#word_frequency').append(word + '(' + score + ') <br/>\n');
  }
}
