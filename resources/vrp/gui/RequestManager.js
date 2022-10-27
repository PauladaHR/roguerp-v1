function RequestManager(){
	var _this = this;
	setInterval(function(){ _this.tick(); },1000);
	this.requests = []
	this.div = document.createElement("div");
	this.div.classList.add("requestManager");
	document.body.appendChild(this.div);
}

RequestManager.prototype.buildText = function(titulo,text){
	return "<div id=\"NotifyBackground\">" + "\<titulo\>" + titulo + "\</titulo\> <br>" + text +" <br><green>Y</green> <red>U</red></div>";
}

RequestManager.prototype.addRequest = function(id,titulo,text,time){
	var request = {}
	request.div = document.createElement("div");
	request.id = id;
	request.time = time-1;
	request.text = text;
	request.titulo = titulo;
	request.div.innerHTML = this.buildText(titulo,text);
	this.requests.push(request);
	this.div.appendChild(request.div);
}

RequestManager.prototype.respond = function(ok){
	if(this.requests.length > 0){
		var request = this.requests[0];
		if(this.onResponse)
		this.onResponse(request.id,ok);
		this.div.removeChild(request.div);
		this.requests.splice(0,1);
	}
}

RequestManager.prototype.tick = function(){
	for(var i = this.requests.length-1; i >= 0; i--){
		var request = this.requests[i];
		request.time -= 1;
		request.div.innerHTML = this.buildText(request.titulo,request.text);
		if(request.time <= 0){
			this.div.removeChild(request.div);
			this.requests.splice(i,1);
		}
	}
}