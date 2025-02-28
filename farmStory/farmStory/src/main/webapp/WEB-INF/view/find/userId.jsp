<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기</title>
    <link rel="stylesheet" href="../css/find/userId.css"/>
</head>
<script>
	//유효성 검사에 사용할 정규표현식
	const reUid   = /^[a-z]+[a-z0-9]{4,19}$/g;
	const rePass  = /^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{5,16}$/;
	const reName  = /^[가-힣]{2,10}$/ 
	const reNick  = /^[a-zA-Zㄱ-힣0-9][a-zA-Zㄱ-힣0-9]*$/;
	const reEmail = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
	const reHp    = /^01(?:0|1|[6-9])-(?:\d{4})-\d{4}$/;
	
	document.addEventListener('DOMContentLoaded', function() {
		
		// 유효성 검사에 사용할 상태 변수
		let isUidOk = false;
		let isPassOk = false;
		let isNameOk = false;
		let isNickOk = false;
		let isEmailOk = false;
		let isHpOk = false;
		
		// 5. 이메일 유효성 검사 (중복/인증처리 포함)
		const btnSendEmail = document.getElementById('btnSendEmail');
		const emailResult = document.querySelector('.emailResult');
		const auth = document.querySelector('.auth');
		let preventDoubleClick = false;
		
		btnSendEmail.onclick = async function(){
			
			const email = formRegister.email.value;
			const name = formRegister.name.value;
			
			// 이중 클릭 방지
			if(preventDoubleClick) {
				// 처음 한번만 ok 다음으로 진행되지 않음
				return;
			}
			
			// 이메일은 입력 타입이 email로 지정되어 있기 때문에 정규표현식 굳이 사용하지 않아도 됨
			if(!value.match(reEmail)) {
				emailResult.innerText = '이메일이 유효하지 않습니다.';
				emailResult.style.color = 'red';
				isEmailOk = false;
				return;
			}
			
			preventDoubleClick = true;
			const response = await fetch('/farmStory/find/userId.do?type=email&email=${email}&name=${name}');
			const data = await response.json();
			
			if(data.count > 0){
				emailResult.innerText = '이미 사용중인 이메일 입니다.';
				emailResult.style.color = 'red';
				isEmailOk = false;
			}else {
				// 인증번호 입력 필드 출력 (auth 클래스)
				// div 기본 형식은 블럭이라 block
				auth.style.display = 'block';
			}
		}
		
			const btnAuthEmail = document.getElementById('btnAuthEmail');
		
			btnAuthEmail.onclick = async function(){
			
			const value = formRegister.auth.value;
			// const jsonData = {"authCode":value};
			
			// 폼 데이터 생성
			const formData = new URLSearchParams();
			formData.append("authCode", value);
			
			// 서버 전송
				// 인증번호는 기밀성이 필요함 파라미터로 보내기 X
				// 아래 코드는 fetch 함수에서 post로 보내기
				// 클라이언트에서 서버로 JSON 데이터 보내줌
				// 체크컨트롤러 dopost 로 수신 처리
			const response = await fetch('/farmStory/find/userId', {
				method: 'POST',
				headers: {'Content-Type': 'application/x-www-form-urlencoded'},
				body: formData
			});

			const data = await response.json();
			console.log(data);
			
			if(data.result > 0){
			emailResult.innerText = '이메일이 인증 되었습니다.';
			emailResult.style.color = 'green';
			isEmailOk = true;
			}else{
			emailResult.innerText = '유효한 인증코드가 아닙니다.';
			emailResult.style.color = 'red';
			isEmailOk = false;
			}
		}
		// 이메일 인증 처리 끝
		// 5. 이메일 유효성 검사 (중복/인증처리 포함) 끝
		
		formRegister.onsubmit = function(e) {
			
			if(!isEmailOk) {
				return false;
			}
		}
		
		const next = document.getElementById('next');
		const name = document.getElementsByName('name')[0];
		const email = document.getElementsByName('email')[0];
		const button = document.getElementsByTagName('button')[0];
		
		next.onclick = function() {
			if(name.value == "") {
				alert('이름을 입력해 주세요.');
				return false;			
			}else if(email.value == "") {
				alert('이메일을 입력해 주세요');
				return false;
			}else if(button.value == "") {
				alert('인증번호를 입력해 주세요.');
				return false;
			}
			return true;
		}
		
		
	});
	
</script>
<body>
    <div id="wrapper">
        <header>
            <div>
                <div class="top">
                    <p>
                        <a href="/farmStory">HOME |</a>
			            <a href="/farmStory/user/login.do">로그인 |</a>
			            <a href="/farmStory/user/terms.do">회원가입 |</a>
			            <a href="#">나의정보 |</a>
			            <a href="/farmStory/user/logout.do">로그아웃 |</a>
			            <a href="/farmStory/admin/main.do">관리자 |</a>
			            <a href="#">고객센터 </a>
                    </p>
                </div>
            </div>
            
            <div>
                <article>
                    <a href="/farmStory" class="logo">
                        <img src="/farmStory/images/logo.png" alt="팜스토리 로고">
                    </a>
                    <a href="#" class="freeShipping">
                        <img src="/farmStory/images/head_txt_img.png" alt="팜스토리 헤더 텍스트">
                    </a>
                </article>
            </div>

            <div>
                <ul>
                    <li>
                        <a href="/farmStory/intro.do">
                            <img src="/farmStory/images/head_menu_line.png" alt="라인">
                            <img src="/farmStory/images/head_menu1.png" alt="팜스토리소개">
                        </a>
                    </li>
                    <li>
                        <a href="/farmStory/basket/list.do">
                            <img src="/farmStory/images/head_menu_badge.png" alt="30%" class="head_badge">
                            <img src="/farmStory/images/head_menu_line.png" alt="라인">
                            <img src="/farmStory/images/head_menu2.png" alt="장보기">
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <img src="/farmStory/images/head_menu_line.png" alt="라인">
                            <img src="/farmStory/images/head_menu3.png" alt="농작물이야기">
                        </a>
                    </li>
                    <li>
                        <a href="/farmStory/event.do">
                            <img src="/farmStory/images/head_menu_line.png" alt="라인">
                            <img src="/farmStory/images/head_menu4.png" alt="이벤트">
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <img src="/farmStory/images/head_menu_line.png" alt="라인">
                            <img src="/farmStory/images/head_menu5.png" alt="커뮤니티">
                        </a>
                    </li>
                </ul>
            </div>
        </header>
        <main>
            <section class="id_find">             
                <form action="/farmStory/find/userId.do" method="POST">
                    <h2>아이디 찾기</h2>
                    <table>
                        <tbody>
                            <tr>
                                <td>이름</td>
                                <td><input type="text" name="name" placeholder="이름 입력"></td>
                            </tr>
                            <tr>
                                <td>이메일</td>
                                <td>
                                    <div>
                                        <input type="email" name="email" placeholder="이메일 입력"/>
                                        <button>인증번호 받기</button>
                                    </div>
                                    <div>
                                        <input type="text" name="auth_code" placeholder="인증번호 입력">
                                        <button>확인</button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </form>
                <p>회원가입시 이메일 주소와 입력한 이메일 주소가 같아야, 인증번호를 받을 수 있습니다.<br>
                    인증번호를 입력 후 확인 버튼을 누르세요.
                </p>
                <div>
                    <a href="#">취소</a>
                    <a href="/farmStory/find/resultUserId.do" id="next">다음</a>
                </div>
            </section>
        </main>
        
        <footer>
            <div class="footer_container">
                <div class="footer_img">
                    <img src="/farmStory/images/footer_logo.png" alt="팜스토리 로고">
                </div>
                <div class="footer_p">
                    <p>
                        (주)팜스토리 / 사업자등록번호 123-45-67890 / 통신판매업신고 제 2013-부산진구-123호 / 벤처기업확인 서울지방중소기업청 제 012345678-9-01234호<br>
                        등록번호 팜스토리01234 (2013.04.01) / 발행인 : 홍길동<br>
                        대표 : 홍길동 / 이메일 : honggildong@gmail.com / 전화 : 01) 234-5678 / 부산광역시 부산진구 부전동 123
                    </p>
                    <p>
                        copyrightⓒ 홍길동 All rights reserved.
                    </p>
                    <p>
                        farmstory ver1.0.1
                    </p>
                </div>
            </div>
        </footer>
</body>
</html>