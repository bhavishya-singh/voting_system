// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require jquery-ui
//= require autocomplete-rails
//= require_tree .
//= require jquery
// require bootstrap-sprockets

function onload(){

    if ($('body').attr('data-loaded') == 'T') {
        console.log("been here");
        return
    }
    $('body').attr('data-loaded','T')
	console.log("loaded");

    var profile_image = document.getElementsByClassName("user-image");
    if(profile_image){
        var current_user_id = $(profile_image).attr('id');
        if(socket === undefined){
            socket =  io(socket_server,{query :"current_user_id="+current_user_id});
        }
        socket.on("pushed_notification",function (result) {
            $('#red_not').show();
            $('#note i').effect("shake",{time:3, distance:5})
            $('.dropdown-notification-content a:eq(0)').after("<a href='/group_polls/"+result.group_poll_id+"/vote'>"+" Group Poll added <b>" +result.group_poll_name+"</b></a>");
        });
    }

    $('#set_user_name').keyup(function () {
        if($(this).val().length >= 3){
            var data = {"user_name": $(this).val()};
            var url = '/check_user_name'
            $.ajax({
                url: url,
                method: "POST",
                data: data,
                success: function(result){
                    if(result.safe =='true'){
                        $('#user_name_not_valid').hide();
                        $('#user_name_available').show();
                    }else{
                        $('#user_name_available').hide();
                        $('#user_name_not_valid').show();
                    }
                },
                error: function(error){
                    console.log(error);
                }

            });
        }else{
            $('#user_name_available').hide();
            $('#user_name_not_valid').show();
        }
    });

 	form = document.getElementById("search_user")
 	if(form){
	 	form.addEventListener('submit',function(event){
	 		console.log("tried submitting");
	 		event.preventDefault();
	 		var url ="/groups/searchuser";
	 		var content = document.getElementById("search_user_name");
	 		var data ={
	 			content: content.value
	 		}
	 		if(!content.value || (content.value && content.value.length < 3)){
	 			console.log("cannot search null");
	 			return;
	 		}
	 		$.ajax({
	 			url: url,
	 			method: "POST",
	 			data: data,
	 			success: function(result){
	 				console.log(result);
	 				$("#result").empty();
	 				for(var i = 0; i < result.length; i++){
	 					var div_id = "user_id:" + result[i].id;
	 					// console.log(div_id);
	 					$("#result").append("<div class='search' id="+div_id+"><h2>"+result[i].user_name+"</h2></div>");
	 					var div = "#" + div_id;
	 					var add_event = document.getElementById(div_id);
	 					add_event.addEventListener("click",function(event){
	 						// console.log("clicked");
	 						event.preventDefault();
	 						// console.log(this.firstChild.innerHTML);
	 						var user_namee = this.firstChild.innerHTML;
	 						var group_id = this.parentNode.getAttribute('class').slice(9);
	 						// console.log(group_id);
	 						var user_id = this.getAttribute('id').slice(8);
	 						// console.log(user_id);
	 						var data ={
					 			user_id: user_id ,
					 			group_id: group_id	
					 		}
					 		var url = "/add_user";
					 		$.ajax({
					 			url: url,
					 			method: "POST",
					 			data: data,
					 			success: function(result){
					 				if(result === null){
					 					console.log("you are not admin of the group");
					 					return;
					 				}
									var user_id = "user_id:"+ result.user_id;
									var div = GetElementInsideContainer("group_users", user_id);
									// console.log(div);
									if(!div){
				 						$("#group_users").prepend("<div id="+user_id+"><h2>"+user_namee+"</h2></div>");
				 						var group_user = GetElementInsideContainer("group_users", user_id);
				 						group_user.addEventListener("click",remove_user);
				 					}else{
				 						console.log("already present");
				 					}

				 				},
					 			error: function(error){
				 					console.log(error);	
				 				}

					 		});


	 					});
	 				};
	 			},
	 			error: function(error){
	 				console.log("error");
	 			}
	 		});

	 	});
	}
    var opened_group = document.getElementsByClassName("opened-group");
 	if(opened_group.length > 0){
        var group_id = $(opened_group[0]).attr('id');
        console.log("was here too once");
        socket.emit('group_opened',{    group_id: group_id  });
        socket.on('emit_group_poll',function(result){
            var folder = document.getElementById("group_polls_add");
            if(folder){
                $(folder).prepend("<a href='/group_polls/"+result.group_poll_id+"/vote'> <div> <h2>"+result.group_poll_name+"</h2> </div> </a>");
            }
        });
    }
    var new_group_poll = document.getElementById("new_group_poll_form");
 	if(new_group_poll){
 	    $("#new_group_poll_form").submit(
            function () {
                console.log("tried submitting");
                event.preventDefault();
                var checked = [];
                var data ={};
                var i = 3;
                $("input:checkbox[name=contestant_ids]:checked").each(function(){
                    var id = $(this).val();
                    checked.push(id);
                    var string = "input:text[name=tag_"+id+"]";
                    data["tag_"+id] = $(string).val();
                });
                if($("#name").val().length < 3 || checked.length < 2){


                    console.log("avoid");
                    return;
                }
                data["group_id"] = $("#group_id").val();
                data["name"] = $("#name").val();
                data["contestant_ids"] = checked;
                data["select_date"] = $("#set_date_group").val();
                data["start_date"] = $("#start_date").val();
                console.log(data);
                $.ajax({
                    url: "/group_polls/create_asyncronously",
                    method: "POST",
                    data: data,
                    success: function(result){
                        if(result.status == "complete"){
                            socket.emit("push_notification", {group_member: result.group_member, group_id: result.group_id, group_poll_id: result.group_poll_id, group_poll_name: result.group_poll_name });
                            socket.emit("group_poll_created",{ group_id: result.group_id, group_poll_id: result.group_poll_id, group_poll_name: result.group_poll_name });
                            console.log("emitede");
                            window.location.replace("http://localhost:3000/group/"+result.group_id+"/show");
                        }else{
                            window.location.replace("http://localhost:3000/group/"+result.group_id+"/show");
                        }
                        // window.location.replace("http://localhost:3000/group/"+result.group_id+"/show");
                    },
                    error: function(error){
                        console.log("error");
                    }
                });
            }
        );

    }

    $('.dropdown-notification').click(function () {
        if($('.dropdown-notification-content').is(':visible')){
            $('.dropdown-notification-content').slideUp();
        }else{
            $('#red_not').hide();
            $('.dropdown-notification-content').slideDown();
        }
    });
	var added =0;
	var add_public_contestant = document.getElementById("add_public_contestant");
	if(add_public_contestant){
		add_public_contestant.addEventListener('click',function(){
			console.log("clicked!");
			event.stopPropagation();
			event.preventDefault();
			added++;
			var id = "added:" + added;
			contestant_element = "<div><label for='contestant_name'>Contestant name</label><input type='text' name='contestant_name[]' class='added_contestant_name'><span id="+id+">delete</span><br><div> <label for='contestant_picture'>Contestant picture</label> <input type='file' name='contestant_pic[]' id='contestant_pic_'> <br> </div><div> <label for='contestant_tag_line'>Contestant tag line</label> <input type='text' name='contestant_tag_line[]' id='contestant_tag_line_'> <br> </div></div>";
			$(contestant_element).insertBefore("#submit");
			var delete_icon = document.getElementById(id);
			delete_icon.addEventListener('click', function(){
				var parent = this.parentNode;
				this.parentNode.parentNode.removeChild(parent);
			});
		});
	}

 	var group_users =  document.getElementById("group_users");
 	if(group_users){
 		group_users = group_users.getElementsByTagName("div");
 	}
 	if(group_users){
 		for(var i = 0 ;i < group_users.length ; i++){
 			group_users[i].addEventListener("click",remove_user);
 		}
 	}

 	function remove_user(event){
 		event.stopPropagation();
 		console.log("*****");
 		console.log(this);
 		var url = "/remove_user";
 		var group_id = this.parentNode.getAttribute('class').slice(9);
 		var user_id = this.getAttribute('id').slice(8);
 		var data ={
			user_id: user_id ,
		    group_id: group_id	
		};
		console.log(group_id);
		console.log(user_id);
		console.log(data);
 		$.ajax({
			url: url,
			method: "POST",
			data: data,
			success: function(result){
				if(result === null){
					console.log("you are not the admin of the group");
					return;
				}
				console.log(result);
				var user_id = "user_id:" + result.user_id; 
				var user_div = GetElementInsideContainer("group_users",user_id);
				user_div.parentNode.removeChild(user_div);

			},
			error: function(error){
			 	console.log(error);	
			}

		});

 	};


    var vote_contestant = document.getElementsByClassName("user_image_button");
    if(vote_contestant.length > 0){
        console.log(vote_contestant);
        for(var  i = 0;  i < vote_contestant.length; i++ ){
            vote_contestant[i].addEventListener("click",function(event){

                var id = this.getAttribute('id');
                id = "your_fav_" + id;
                document.getElementById(id).checked = true;
                console.log(document.getElementById(id).checked);
                for(var  i1 = 0;  i1 < vote_contestant.length; i1++ ){
                    vote_contestant[i1].style.backgroundColor = "#666666";
                }
                this.style.backgroundColor = "#99badd";
            });
        }

    }

    function check_warn() {
        if($('.alert').text().length <=0 && $('.notice').text().length <= 0){
            $('#warn').hide();
        }
    };
    check_warn();



    var percentageArray = new Array();
    var answerArray = new Array();
    var votes = document.getElementsByClassName("votes");
    if(votes.length > 0){
        var array_votes = [];
        var total_votes = 0;
        for(var i = 0; i < votes.length ;i++ ){
            array_votes[i] = parseInt(votes[i].innerHTML);
            total_votes += array_votes[i];
            percentageArray.push(parseInt(votes[i].innerHTML));
            answerArray.push($(votes[i]).parent().find('h2').text());
            votes[i].innerHTML = "0";
        }
        var array_change = [];
        for(var i = 0; i < votes.length ;i++) {
            array_change[i] = 0;
        }


        for(var i = 0; i < votes.length ;i++) {
            percentageArray[i] = percentageArray[i]/total_votes * 100;
        }


        $.fn.createBarchart = function (optionvariables) {
            var chartContainer = $(this);
            var defaults = {
                'maxWidth': 244
            };
            var options = $.extend({}, defaults, optionvariables);
            var self = $(this),
                graphContainer = self.parent().find('.graph-container .graph'),
                barChart = $('<ul/>', { class: 'bar-chart' });

            barChart.appendTo(chartContainer);

            $.each(answerArray, function(index, value) {
                var chartAnswer = $('<li/>', { class: 'answer-' + index }),
                    answerLabel = $('<span/>', { class: 'label', text: value }),
                    percentageValue = percentageArray[index].toString(),
                    answerPercentage = $('<span/>', { class: 'percentage', text: percentageValue.replace('.', ',') + '%' }),
                    barTrack = $('<span/>', { class: 'bar-track' }),
                    bar = $('<span />', { class: 'bar', style: 'width: ' + percentageValue + '%;' });

                chartAnswer.appendTo(barChart);
                answerLabel.appendTo(chartAnswer);
                answerPercentage.appendTo(chartAnswer);
                barTrack.appendTo(chartAnswer);
                bar.appendTo(barTrack);
            });

                console.log("inside to create canvas");
                barChart.chart(
                    {
                        graphContainer: graphContainer
                    }
                );

        };

        $.fn.chart = function (optionvariables) {
            var chart = $(this);
            var defaults = {
                'canvasSize': 220,
                'graphContainer': $('.graph-container .graph')
            };
            var options = $.extend({}, defaults, optionvariables);

            return chart.each(function () {
                var listItem = chart.find('li'),
                    listItems = listItem.length,
                    canvas = document.createElement('canvas'),
                    canvasWidth = options.canvasSize,
                    canvasHeight = options.canvasSize,
                    graphContainer = options.graphContainer,
                    total = 0,
                    totalPercentage = 0,
                    data = [],
                    newData = [],
                    i = 0,
                    startingAngle,
                    arcSize,
                    endingAngle;

                $.each(percentageArray, function(index, value) {
                    newData.push(3.6 * value);
                });

                function sumTo(a, i) {
                    var sum = 0;
                    for (var j = 0; j < i; j++) {
                        sum += a[j];
                    }
                    return sum - 90;
                }

                function degreesToRadians(degrees) {
                    return ((degrees * Math.PI)/180);
                }

                canvas.setAttribute('width', canvasWidth);
                canvas.setAttribute('height', canvasHeight);
                canvas.setAttribute('id', 'chartCanvas');
                graphContainer.append(canvas);

                var cvs = document.getElementById('chartCanvas'),
                    ctx = cvs.getContext('2d'),
                    centerX = canvasWidth / 2,
                    centerY = canvasHeight / 2,
                    radius = canvasWidth / 2;

                ctx.clearRect(0, 0, canvasWidth, canvasHeight);

                listItem.each(function(e) {
                    startingAngle = degreesToRadians(sumTo(newData, i));
                    arcSize = degreesToRadians(newData[i]);
                    endingAngle = startingAngle + arcSize;
                    ctx.beginPath();
                    ctx.moveTo(centerX, centerY);
                    ctx.arc(centerX, centerY, radius, startingAngle, endingAngle, false);
                    ctx.closePath();
                    ctx.fillStyle = $(this).find('.bar').css('backgroundColor');
                    ctx.fill();
                    ctx.restore();
                    i++;
                });

                ctx.beginPath();
                ctx.moveTo(centerX, centerY);
                ctx.arc(centerX, centerY, radius * .45, 0, 2 * Math.PI, false);
                ctx.closePath();
                ctx.fillStyle = $('body').css('backgroundColor');
                ctx.fill();
            });
        };

        $('#live-poll-area .answer-list').createBarchart();

        var price = array_votes;

        var chartH = $('#svg').height();
        var chartW = $('#svg').width();




        var increment = function () {
            var change = false;
            for(var j = 0 ; j < array_votes.length ; j++){
                //console.log(array_change[j] + " ==== "+ array_votes[j]);
                if(array_change[j] < array_votes[j]){
                    array_change[j]++;
                    votes[j].innerHTML = "" + array_change[j] ;
                    change = true;
                    //console.log(array_change[j]);
                }
            }
            if(!change){
                console.log("cleared");
                stop_interval();
            }
        }
        var caller = setInterval(increment, 1000);
        var stop_interval = function(){
            clearInterval(caller);
        }
    }
    console.log("here");
    var public_poll_list = document.getElementsByClassName("public_polls_list");
    if(public_poll_list.length > 0){
        $('.public_polls_list').slick({
            dots: true,
            slidesToShow: 6,
            slidesToScroll: 2,
            touchMove: false,
            responsive: false
        });
        $('.public_polls_list').ready(function () {
            $('.public_poll_items').each(function () {
                $(this).show();
            });
        });
    }
    var select_date = document.getElementById("set_date_group");
    if(select_date){
        $(select_date).change(function () {
            if($(select_date).is(":checked")){
                $("#start_date_select").slideDown();
            }else{
                $("#start_date_select").slideUp();
            }
        });
    }
    var group_poll_checkbox = document.getElementsByClassName("new_group_poll_checkbox");
    if(group_poll_checkbox.length > 0){
        $(".new_group_poll_checkbox").each(function(){
            $(this).change(function () {
                var val_ad = $(this).val();
                if($(this).is(":checked")){
                    $(this).parent().append("<div id='tag_"+val_ad+"'><label for='tag_"+val_ad+"'>Tag Line</label><input type='text' name='tag_"+val_ad+"'></div>");
                }else{
                    $("#tag_"+val_ad).remove();
                }
            });
        });
    }

 	var vote_form = document.getElementById("vote_form");
 	if(vote_form){
 		console.log("tag");
 		vote_form.addEventListener("submit", function(event){
 			event.preventDefault();
 			if ($('input[name=your_fav]:checked').length) {
           		vote_form.submit();
      		}
      		else {
           		console.log("Atleast one is to be selected"); 
      		}
 		});
 	}



};

function GetElementInsideContainer(containerID, childID) {
    var elm = null;
    var elms = document.getElementById(containerID).getElementsByTagName("*");
    console.log(elms);
    for (var i = 0; i < elms.length; i++) {
        if (elms[i].id === childID) {
            elm = elms[i];
            break;
        }
    }
    return elm;
}
$(document).ready(onload);
$(document).on('turbolinks:load',onload);

var socket_server = "http://localhost:8000";
var socket;


function hide_warning() {
    $('#warn').slideUp();
}