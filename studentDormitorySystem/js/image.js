//布局的变量
var config={
	imgWidth: 520,
	dotWidth: 14,
	doms:{
		divContainer: document.querySelector(".container"),
		images: document.querySelector(".container .images"),
		dots: document.querySelector(".container .dots"),
		arrows: document.querySelector(".container .arrow")
	},
	currentIndex:0,  //实际的图片索引
	timer:{
		duration:16,//运动间隔的时间
		total:640,//  运动的总时间
		id:null //计时器的id  方便清除
	},
	autoTimer:null
}

config.imgNumer = config.doms.images.children.length;
// 初始化生成dot的span
function initDots(){
	for(var i = 0 ;i< config.doms.images.children.length;i++){
		var dot = document.createElement("span");
		config.doms.dots.appendChild(dot);
	}
}
//初始化长度
function initWidth(){
	config.doms.images.style.width = config.imgWidth * (config.imgNumer+2) + "px";
	config.doms.dots.style.width = config.dotWidth * config.imgNumer +"px";
}

//先设置点击事件进行切换图片  首尾添加元素
function initElements(){
	var children = config.doms.images.children;
	// 深度克隆
	var newImg = children[0].cloneNode(true);
	config.doms.images.appendChild(newImg);
	var first = children[0];
	newImg = children[children.length-2].cloneNode(true);
	config.doms.images.insertBefore(newImg,first);//参数1 是要插入的图片  参数2是插入位置的图片
}
function initPosition(){
	var left = (-config.currentIndex - 1) * config.imgWidth;
	//整体的image容器向左移动
	config.doms.images.style.marginLeft = left +"px";
}

function setDotStatus(){
	for(var i = 0; i< config.doms.dots.children.length;i++){
		var dot = config.doms.dots.children[i];
		if(i ===  config.currentIndex){
			dot.className="active";
		}else{
			dot.className = "";
		}
	}
}
function init(){
	initDots();
	initWidth();
	initElements();
	initPosition();
	setDotStatus();
}
init();

//切换功能


function switchTo(index,direction){
	if(index === config.currentIndex){
		return;
	}
	if(!direction){
		direction ="right"
	}
	
	//最终的margin-left 动态的变化
	var newLeft =(-index -1)*config.imgWidth;
	animateSwitch();
	
	config.currentIndex = index;
	setDotStatus();
	
	function animateSwitch(){
		stopAnimate();//先停止之前的动画
		//计算运动的次数
		var  number = Math.ceil(config.timer.total / config.timer.duration);
		var currentNumber = 0;
		//计算一个间隔运动的距离
		var distance;
		var marginLeft = parseFloat(getComputedStyle(config.doms.images).marginLeft);
		var totalWidth = config.imgNumer * config.imgWidth;//总的长度
		//判断方向
		//向左移动为负值  向右移动为正值
		/**
		 * 关系式  图片方向向左时 marginLeft 的值在减小(绝对值增大)  即newLeft的值在减小(绝对值增大) 
		  * 当新移入的left值 小于  原来的marginLeft时  移动的距离是  负值   newLeft- marginLeft
		 *  当图片要循环时 newLeft 的值大于原来的marginLeft  移动距离= -(总距离减去两者之间的距离)  
		 * 
		 *  图片方向向右时 marginLeft 的值在增大(绝对值减小)  即newLeft的值在增大(绝对值减小) 
		  * 新移入的newleft值 大于原来的marginLeft，移动的距离是正值newLeft- marginLeft
		 * 当图片要循环时 newLeft 的值小于原来的marginLeft  移动距离= 总距离减去两者之间的距离  
		 */
		
		if(direction === "left"){
			if(newLeft < marginLeft){
				distance = newLeft - marginLeft;
			}else{//处理循环的
				distance = -(totalWidth - Math.abs(newLeft-marginLeft));
			}
		}else{
			if(newLeft > marginLeft){
				distance = newLeft - marginLeft;
			}else{
				distance = totalWidth - Math.abs(newLeft - marginLeft);
			}
		}
		//计算每次改变的距离
		var everyDistance = distance / number;
		config.timer.id= setInterval(function(){
			//改变marginLeft
			marginLeft += everyDistance;
			if(direction ==="left" && Math.abs(marginLeft) > totalWidth){
				marginLeft += totalWidth;
			}
			if(direction ==="right" && Math.abs(marginLeft) < config.imgWidth){
				marginLeft -= totalWidth;
			}
			config.doms.images.style.marginLeft = marginLeft +"px";
			currentNumber ++;
			if(currentNumber === number){
				stopAnimate();
			}
		},config.timer.duration)
	}
	
	function stopAnimate(){
		clearInterval(config.timer.id);
		config.timer.id=null;
	}
}
//classList.contains()  类中包含的语句
config.doms.arrows.onclick = function(e){
	if(e.target.classList.contains("right")){toRight();}
	else{toLeft();}
}
function toRight(){
	var target = config.currentIndex + 1;	
	if(target >= config.imgNumer){
		target = 0;
	}
	switchTo(target,"left");
}
function toLeft(){
	var target = config.currentIndex -1;
	if(target < 0){
		target = config.imgNumer - 1;
	}
	switchTo(target,"right");
}

//鼠标移入的时候停止间隔
config.doms.divContainer.onmouseenter= function(){
	clearInterval(config.autoTimer);
	config.autoTimer = null;
}
//鼠标离开时执行间隔
config.doms.divContainer.onmouseleave = function(){
	config.autoTimer = setInterval(toRight,2000);
}

config.doms.dots.onclick= function(e){
	if(e.target.tagName === "SPAN"){
		var index = Array.from(this.children).indexOf(e.target);
		switchTo(index,index>config.currentIndex?"left":"right");
	}
}