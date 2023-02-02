$(document).ready(function () {
    //현재 우리가 보고있는 슬라이더의 번호 // 곧 보게될 슬라이드의 번호
    //가능한 슬라이드의 번호 0 1 2 3 4
    // ＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠초기선언부＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠
    var timer = 3000; //자동실행 시간 간격
    // cur(=current:현재 우리가 보고있는 슬라이더 변수)
    // 가장 최초의순간에는 0번째(초기화)

    var cur = 0;
    // 클래스pic의 갯수(슬라이드의 갯수)가 변수 len에 들어간다.
    // 왜 len이 들어가냐? 슬라이드의 갯수가 바뀌게 될때마다 사용할 수 있도록 하기 위해서
    var len = $('.pic').length;
    for (i = 0; i < len; i++) {
        $('#dots').append("<button type='button'></button>");
    }
    paging();
    // 아이디 dots안에 있는 버튼중에 첫째에게 클래스를 준다. 어떤 클래스? active클래스!(클래스 앞에 .(쩜)쓰지말기 why?addClass자체가 클래스이기때문)
    // 첫번째 dots 알약모양으로 클래스를 준다.
    $('#dots button').eq(0).addClass('active');

    function paging() {
        // 전체 슬라이드의 갯수와 현재 우리가 보고있는 슬라이드의 번호를
        //#page라는 곳에 써주는일
        $('#page').text(cur + 1 + '/' + len);

        // ＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠초기선언부＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠
    }
    // ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡmark.1ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

    // next라는 함수가 원래 있어서 daum으로 변수이름을 설정해준다
    // function daum() {
    //     // ※정리: 처음순간 0번째를 보여주고 모두 숨긴다음에 eq번째 슬라이드를 보여준다

    //     // cur는 1이 증가한다.
    //     cur++;
    //     if (cur >= 5) {
    //         cur = 0;
    //     }

    //     // .pic=슬라이더이름, fadeout=사라지다.
    //     // 모든 슬라이드를 사라지게하다.
    //     $('.pic').fadeOut();
    //     // ○번째를 부르는 함수 = .eq()
    //     $('.pic').eq(cur).fadeIn();
    // }
    // //이전그림을 본다 = ijun()
    // function ijun() {
    //     cur--;
    //     if (cur < 0) {
    //         cur = 4;
    //     }
    //     // .pic=슬라이더이름, fadeout=사라지다.
    //     // 모든 슬라이드를 사라지게하다.
    //     $('.pic').fadeOut();
    //     // ○번째를 부르는 함수 = .eq()
    //     $('.pic').eq(cur).fadeIn();
    // }

    // // id:next를 눌렀을때, daum함수를 실행한다
    // $('#next').click(function () {
    //     daum();
    // });

    // //id:prev를 눌렀을때, ijun함수를 실행한다
    // $('#prev').click(function () {
    //     ijun();
    // });

    // ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡmark.2ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    // ＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠번호관리부＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠

    function sliding(dir) {
        cur = cur + dir; // cur를 dir만큼 증가시킨다.
        if (cur >= len) {
            //(갯수)를 의미하는 숫자가 즉, 우리가 봐서는 안될 슬라이드의 번호를 말한다.
            cur = 0;
        } else if (cur < 0) {
            cur = len - 1;
        }
        //  ＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠번호관리부＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠

        //  ＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠번호수행부＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠
        $('.pic').fadeOut();
        $('.pic').eq(cur).fadeIn();
        //페이지갱신팀
        paging();
        // 알약모양 클래스 뺏기
        $('#dots button').removeClass('active');
        // 현재 (번호)번째에 알약모양 클래스 주기
        $('#dots button').eq(cur).addClass('active');
    }

    //  ＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠번호수행부＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠

    //  ＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠버튼실행부＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠

    // 이전그림을 보자
    $('#next').click(function () {
        sliding(1);
    });

    // 다음그림을 보자
    $('#prev').click(function () {
        sliding(-1);
    });
    //  ＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠버튼실행부＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠

    //  ＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠자동실행부＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠
    var auto = setInterval(function () {
        sliding(1);
    }, timer);
    // ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    // 마우스를 올리면 자동으로 슬라이더 넘어가는걸 멈춰라
    $('#slider').mouseenter(function () {
        clearInterval(auto);
    });
    $('#slider').mouseleave(function () {
        auto = setInterval(function () {
            sliding(1);
        }, timer);
    });

    //  ＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠자동실행부＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠

    //dot실행부
    //1. 방금누른 dot버튼이 몇번째 버튼인지?
    //2. cur가 0이었다 라고 뻥치기
    //3. sliding(번째수)

    //index함수는 물어보는소리 , eq()는 부르는 소리
    $('#dots button').click(function () {
        var btnidx = $(this).index();
        cur = 0;
        sliding(btnidx);
    });
});
