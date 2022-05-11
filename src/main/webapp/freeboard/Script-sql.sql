
Create table freeboard (
    id number constraint PK_freeboard_id Primary Key,   -- 자동 증가 컬럼
    name varchar2(10) not null,
    password varchar2(100) null,
    email varchar2(100) null,
    subject varchar2(100) not null, -- 글 제목
    content varchar2(2000),  -- 글 내용
    inputdate varchar2(100) not null, -- 글쓴 날짜
        -- 질문답변형게시판 (masterid, readcount, step => 3개의 컬럼 필요)
    masterid  number default 0, -- 답변의 글들을 그룹핑할 때 사용
    readcount number default 0, -- 글 조회수 
    replynum number default 0,  
    step number default 0
    );
    
select * from freeboard;