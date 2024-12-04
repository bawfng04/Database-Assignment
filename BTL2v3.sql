
---------------------- TẠO DATABASE --------------------------------

--Người dùng hệ thống
CREATE TABLE Users(
    UsernameID INT IDENTITY (1,1) PRIMARY KEY,
    UserEmail VARCHAR(255),
    UserPhone VARCHAR(10),
    UserPassword VARCHAR(255),
    UserAddress VARCHAR(255),
    UserImage VARCHAR(255),
    Username VARCHAR(255),
)

--Bảng Admin
CREATE TABLE Admin(
    AdminID INT PRIMARY KEY,
    FOREIGN KEY (AdminID) REFERENCES Users(UsernameID),
);

--Bảng giảng viên
CREATE TABLE Teacher(
    TeacherID INT PRIMARY KEY,
    TeacherDescription VARCHAR(255),

    FOREIGN KEY (TeacherID) REFERENCES Users(UsernameID),
)

--Bảng danh mục
CREATE TABLE Category(
    CategoryID INT IDENTITY (1,1) PRIMARY KEY,
    CategoryName VARCHAR(255),
    CategoryDescription VARCHAR(255),
);


--Giỏ hàng
CREATE TABLE Cart(
    CartID INT IDENTITY (1,1) PRIMARY KEY,
);


--Bảng khoá học
CREATE TABLE Course(
    CourseID INT IDENTITY (1,1) PRIMARY KEY,
    CourseName VARCHAR(255),
    CourseStatus VARCHAR(255),
    CourseDescription VARCHAR(255),
    CoursePrice INT,
    CourseImage VARCHAR(255),
    CourseStartDate DATE,
    CourseEndDate DATE,
    CategoryID INT,

    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
);


--Chương
CREATE TABLE Chapter(
    ChapterName VARCHAR(255),
    CourseID INT,

    PRIMARY KEY (ChapterName, CourseID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

--Tài liệu
CREATE TABLE Document(
    DocumentID INT IDENTITY (1,1) PRIMARY KEY,
    CourseID INT,
    ChapterName VARCHAR(255),
    DocumentAuthor VARCHAR(255),
    DocumentTitle VARCHAR(255),
    DocumentSize INT,
    DocumentType VARCHAR(255),
    DocumentContent VARCHAR(255),

    FOREIGN KEY (ChapterName, CourseID) REFERENCES Chapter(ChapterName, CourseID)
);

--Bài học
CREATE TABLE Lesson(
    LessonOrder INT,
    CourseID INT,
    ChapterName VARCHAR(255),
    LessonTitle VARCHAR(255),
    LessonContent VARCHAR(255),
    LessonDuraion TIME,

    PRIMARY KEY (LessonOrder, CourseID, ChapterName),
    FOREIGN KEY (ChapterName, CourseID) REFERENCES Chapter(ChapterName, CourseID),
)

--Bài tập
CREATE TABLE Exercise(
    ExerciseOrder INT,
    LessonOrder INT,
    CourseID INT,
    ChapterName VARCHAR(255),
    ExerciseTitle VARCHAR(255),
    ExerciseAnswer VARCHAR(255),
    ExerciseCorrectAnswerNumber INT,
    ExerciseContent VARCHAR(255),

    PRIMARY KEY (ExerciseOrder, LessonOrder, CourseID, ChapterName),

    FOREIGN KEY (LessonOrder, CourseID, ChapterName) REFERENCES Lesson(LessonOrder, CourseID, ChapterName),
)

--Bài kiểm tra
CREATE TABLE Test(
    TestOrder INT,
    CourseID INT,
    ChapterName VARCHAR(255),
    TestDuration TIME,

    PRIMARY KEY (TestOrder, CourseID, ChapterName),
    FOREIGN KEY (ChapterName, CourseID) REFERENCES Chapter(ChapterName, CourseID),
)

--Câu hỏi
CREATE TABLE Question(
    QuestionID INT IDENTITY (1,1) PRIMARY KEY,
    QuestionScore INT,
    QuestionContent VARCHAR(255),
)

--Lựa chọn
CREATE TABLE Options(
    QuestionID INT,
    OptionName VARCHAR(255) UNIQUE,
    IsCorrect BIT, --Đúng hay sai
    OptionContent VARCHAR(255), --Nội dung lựa chọn

    PRIMARY KEY (QuestionID, OptionName),
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID),
)

--Câu hỏi thuộc bài kiểm tra
CREATE TABLE QuestionTest(
    QuestionID INT,
    TestOrder INT,
    CourseID INT,
    ChapterName VARCHAR(255),

    PRIMARY KEY (QuestionID, TestOrder, CourseID, ChapterName),
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID),
    FOREIGN KEY (TestOrder, CourseID, ChapterName) REFERENCES Test(TestOrder, CourseID, ChapterName),
)

--Bảng học viên
CREATE TABLE Student(
    StudentID INT IDENTITY (1,1) PRIMARY KEY,
    CartID INT,
    OptionName VARCHAR(255),
    QuestionID INT,

    FOREIGN KEY (StudentID) REFERENCES Users(UsernameID),
    FOREIGN KEY (CartID) REFERENCES Cart(CartID),
    FOREIGN KEY (OptionName) REFERENCES Options(OptionName),
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID),
)

--Người đại diện
CREATE TABLE Guardian(
    GuardianID INT IDENTITY (1,1) PRIMARY KEY,
    StudentID INT,
    GuardianName VARCHAR(255),
    GuardianEmail VARCHAR(255),
    GuardianPhone VARCHAR(10),

    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
)

--Giảng viên dạy khoá học
CREATE TABLE TeacherCourse(
    TeacherID INT,
    CourseID INT,
    PRIMARY KEY (TeacherID, CourseID),
    FOREIGN KEY (TeacherID) REFERENCES Teacher(TeacherID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
)


--Phiếu giảm giá
CREATE TABLE Coupon(
    CouponID INT IDENTITY (1,1) PRIMARY KEY,
    CouponTitle VARCHAR(255),
    CouponValue INT,
    CouponType VARCHAR(255),
    CouponStartDate DATE,
    CouponExpire DATE,
    CouponMaxDiscount INT,
)

--Bảng Chỉnh sửa
CREATE TABLE Edit (
    EditID INT IDENTITY (1,1) PRIMARY KEY,
    EditTime TIME,
    EditDescription VARCHAR(255),
    EditAdminID INT,
    EditCouponID INT,
    EditCourseID INT,

    FOREIGN KEY (EditCourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (EditAdminID) REFERENCES Admin(AdminID),
    FOREIGN KEY (EditCouponID) REFERENCES Coupon(CouponID),
);

--Khoá học thuộc giỏ hàng
CREATE TABLE CourseCart(
    CourseID INT,
    CartID INT,

    PRIMARY KEY (CourseID, CartID),

    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (CartID) REFERENCES Cart(CartID),

)

--Khoá học có học viên
CREATE TABLE CourseStudent(
    CourseID INT,
    StudentID INT,

    PRIMARY KEY (CourseID, StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
)


--Đánh giá
CREATE TABLE Review(
    ReviewID INT IDENTITY (1,1) PRIMARY KEY,
    CourseID INT,
    ReviewScore INT,
    ReviewContent VARCHAR(255),
    StudentID INT,

    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
)

--Phương thức thanh toán
CREATE TABLE PaymentMethod(
    PaymentCode VARCHAR(255) PRIMARY KEY, --mã thanh toán
    PayerName VARCHAR(255),
    PaymentDate DATE,
)

--Momo
CREATE TABLE Momo(
    PaymentCode VARCHAR(255) PRIMARY KEY, --mã thanh toán
    PhoneNumber VARCHAR(10),

    FOREIGN KEY (PaymentCode) REFERENCES PaymentMethod(PaymentCode),
)

--Internet Banking
CREATE TABLE InternetBanking(
    PaymentCode VARCHAR(255) PRIMARY KEY, --mã thanh toán
    BankName VARCHAR(255),

    FOREIGN KEY (PaymentCode) REFERENCES PaymentMethod(PaymentCode),
)

--VISA
CREATE TABLE VISA(
    PaymentCode VARCHAR(255) PRIMARY KEY, --mã thanh toán
    CardNumber VARCHAR(16),
    ExpireDate DATE,

    FOREIGN KEY (PaymentCode) REFERENCES PaymentMethod(PaymentCode),
)


--Đơn hàng
CREATE TABLE Orders(
    OrderID INT IDENTITY (1,1) PRIMARY KEY,
    OrderPaymentStatus VARCHAR(255),
    OrderDate DATE,
    OrderPaymentCode VARCHAR(255),
    StudentID INT,
    CouponID INT,

    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (OrderPaymentCode) REFERENCES PaymentMethod(PaymentCode),
    FOREIGN KEY (CouponID) REFERENCES Coupon(CouponID),
)

--Khoá học thêm vào đơn hàng
CREATE TABLE CourseOrder(
    CourseID INT,
    OrderID INT,

    PRIMARY KEY (CourseID, OrderID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
)


---------------------- INSERT DATA --------------------------------

--Người dùng hệ thống
INSERT INTO Users (UserEmail, UserPhone, UserPassword, UserAddress, UserImage, Username)
VALUES
('LeHoangNam@gmail.com', '0911002001', 'nam123', 'Da Nang', 'LeHoangNam.jpg', 'Le Hoang Nam'),
('DoNgocAnh@gmail.com', '0909998877', 'anh789', 'Hue', 'DoNgocAnh.jpg', 'Do Ngoc Anh'),
('NguyenMinhTri@gmail.com', '0988455623', 'tri456', 'Hai Phong', 'NguyenMinhTri.jpg', 'Nguyen Minh Tri'),
('PhanQuocDung@gmail.com', '0936781254', 'dung000', 'Ha Noi', 'PhanQuocDung.jpg', 'Phan Quoc Dung'),
('BuiKieuTrinh@gmail.com', '0923346789', 'trinh321', 'Ho Chi Minh', 'BuiKieuTrinh.jpg', 'Bui Kieu Trinh'),
('VoThiLan@gmail.com', '0945567892', 'lan999', 'Da Lat', 'VoThiLan.jpg', 'Vo Thi Lan'),
('NgoDucHoa@gmail.com', '0916789456', 'hoa222', 'Can Tho', 'NgoDucHoa.jpg', 'Ngo Duc Hoa'),
('DangGiaHuy@gmail.com', '0978854123', 'huy456', 'Nha Trang', 'DangGiaHuy.jpg', 'Dang Gia Huy'),
('NgoNgocMi@gmail.com', '0901234567', 'mi789', 'Quang Nam', 'NgoNgocMi.jpg', 'Ngo Ngoc Mi'),
('TranThiNhuY@gmail.com', '0987654321', 'y123', 'Quang Ngai', 'TranThiNhuY.jpg', 'Tran Thi Nhu Y'),
('DangMinhNhut@gmail.com', '0912345678', 'nhut456', 'Quang Tri', 'DangMinhNhut.jpg', 'Dang Minh Nhut'),
('LeVanTam@gmail.com', '0912345679', 'tam123', 'Da Nang', 'LeVanTam.jpg', 'Le Van Tam'),
('NguyenThiHoa@gmail.com', '0912345680', 'hoa123', 'Hue', 'NguyenThiHoa.jpg', 'Nguyen Thi Hoa'),
('TranVanBinh@gmail.com', '0912345681', 'binh123', 'Hai Phong', 'TranVanBinh.jpg', 'Tran Van Binh'),
('PhamThiLan@gmail.com', '0912345682', 'lan123', 'Ha Noi', 'PhamThiLan.jpg', 'Pham Thi Lan'),
('HoangVanSon@gmail.com', '0912345683', 'son123', 'Ho Chi Minh', 'HoangVanSon.jpg', 'Hoang Van Son'),
('LeThiMai@gmail.com', '0912345684', 'mai123', 'Da Lat', 'LeThiMai.jpg', 'Le Thi Mai'),
('NguyenVanHung@gmail.com', '0912345685', 'hung123', 'Can Tho', 'NguyenVanHung.jpg', 'Nguyen Van Hung'),
('TranThiThu@gmail.com', '0912345686', 'thu123', 'Nha Trang', 'TranThiThu.jpg', 'Tran Thi Thu'),
('PhamVanKhanh@gmail.com', '0912345687', 'khanh123', 'Quang Nam', 'PhamVanKhanh.jpg', 'Pham Van Khanh'),
('NguyenThiBich@gmail.com', '0912345688', 'bich123', 'Quang Ngai', 'NguyenThiBich.jpg', 'Nguyen Thi Bich'),
('TranVanMinh@gmail.com', '0912345689', 'minh123', 'Quang Tri', 'TranVanMinh.jpg', 'Tran Van Minh'),
('NguyenThiLan@gmail.com', '0912345690', 'lan123', 'Ha Noi', 'NguyenThiLan.jpg', 'Nguyen Thi Lan'),
('LeVanHung@gmail.com', '0912345691', 'hung123', 'Ho Chi Minh', 'LeVanHung.jpg', 'Le Van Hung'),
('PhamThiLinh@gmail.com', '0912345692', 'linh123', 'Da Nang', 'PhamThiLinh.jpg', 'Pham Thi Linh'),
('VoVanThanh@gmail.com', '0912345693', 'thanh123', 'Can Tho', 'VoVanThanh.jpg', 'Vo Van Thanh'),
('TruongThiMy@gmail.com', '0912345694', 'my123', 'Hue', 'TruongThiMy.jpg', 'Truong Thi My'),
('NguyenVanKhang@gmail.com', '0912345695', 'khang123', 'Binh Duong', 'NguyenVanKhang.jpg', 'Nguyen Van Khang'),
('PhanThiHuyen@gmail.com', '0912345696', 'huyen123', 'Vinh Long', 'PhanThiHuyen.jpg', 'Phan Thi Huyen'),
('DangVanTien@gmail.com', '0912345697', 'tien123', 'Bac Lieu', 'DangVanTien.jpg', 'Dang Van Tien'),
('HoangThiAnh@gmail.com', '0912345698', 'anh123', 'Dong Nai', 'HoangThiAnh.jpg', 'Hoang Thi Anh'),
('DuongVanLong@gmail.com', '0912345699', 'long123', 'Tay Ninh', 'DuongVanLong.jpg', 'Duong Van Long'),
('LeVanDat@gmail.com', '0912345700', 'dat123', 'An Giang', 'LeVanDat.jpg', 'Le Van Dat'),
('NguyenThiMai@gmail.com', '0912345701', 'mai123', 'Binh Thuan', 'NguyenThiMai.jpg', 'Nguyen Thi Mai'),
('PhamVanNam@gmail.com', '0912345702', 'nam123', 'Khanh Hoa', 'PhamVanNam.jpg', 'Pham Van Nam'),
('TranVanHieu@gmail.com', '0912345703', 'hieu123', 'Binh Phuoc', 'TranVanHieu.jpg', 'Tran Van Hieu'),
('VoThiNgoc@gmail.com', '0912345704', 'ngoc123', 'Cần Thơ', 'VoThiNgoc.jpg', 'Vo Thi Ngoc'),
('LuongVanTuan@gmail.com', '0912345705', 'tuan123', 'Quang Ninh', 'LuongVanTuan.jpg', 'Luong Van Tuan'),
('NguyenThiKim@gmail.com', '0912345706', 'kim123', 'Hai Phong', 'NguyenThiKim.jpg', 'Nguyen Thi Kim'),
('TranVanTien@gmail.com', '0912345707', 'tien123', 'Thua Thien Hue', 'TranVanTien.jpg', 'Tran Van Tien'),
('LeVanBinh@gmail.com', '0912345708', 'binh123', 'Long An', 'LeVanBinh.jpg', 'Le Van Binh');



--Bảng Admin
INSERT INTO Admin (AdminID)
VALUES
(1),
(2),
(3);

--Bảng giảng viên
INSERT INTO Teacher (TeacherID, TeacherDescription)
VALUES
(4, 'Giảng viên có 20 năm kinh nghiệm trong việc giảng dạy môn sinh học'),
(5, 'Có chứng chỉ TOEIC 900, 5 năm kinh nghiệm giảng dạy tiếng Anh'),
(6, 'Giảng viên có 10 năm kinh nghiệm trong việc giảng dạy môn toán'),
(7, 'Giải nhất cuộc thi Toán học quốc gia 2020'),
(8, 'Giảng viên chuyên ngành Toán học, từng giảng dạy tại trường Đại học Khoa học Tự nhiên'),
(9, 'Giảng viên tiếng Anh, có chứng chỉ IELTS 8.0, kinh nghiệm giảng dạy cho học sinh quốc tế'),
(10, 'Giảng viên Kinh tế, nghiên cứu chuyên sâu về thị trường chứng khoán'),
(11, 'Giảng viên Lịch sử, từng tham gia nhiều dự án nghiên cứu về văn hóa Việt Nam'),
(12, 'Giảng viên Hóa học, có kinh nghiệm giảng dạy thực hành trong phòng thí nghiệm'),
(13, 'Giảng viên Vật lý, từng đạt giải nhì cuộc thi Vật lý quốc gia cho sinh viên'),
(14, 'Giảng viên Tin học, chuyên gia về lập trình web và ứng dụng di động'),
(15, 'Giảng viên Ngữ văn, có nhiều năm kinh nghiệm chấm thi THPT Quốc gia'),
(16, 'Giảng viên Âm nhạc, nghệ sĩ guitar cổ điển, đã từng biểu diễn tại nhiều chương trình quốc tế'),
(17, 'Giảng viên Mỹ thuật, họa sĩ chuyên ngành hội họa, tác phẩm từng được triển lãm tại nhiều nước'),
(18, 'Giảng viên Thể dục, HLV thể hình, từng đạt giải nhất cuộc thi thể hình quốc gia'),
(19, 'Giảng viên Kỹ thuật, chuyên gia về cơ khí, từng tham gia nhiều dự án lớn về xây dựng'),
(20, 'Giảng viên Ngoại ngữ, có chứng chỉ TOEFL 100, từng giảng dạy tại trường Đại học Ngoại ngữ');

--Bảng danh mục
INSERT INTO Category (CategoryName, CategoryDescription)
VALUES
('Phân tích dữ liệu', 'Các khóa học về phân tích và xử lý dữ liệu lớn'),
('UI/UX Design', 'Khóa học về thiết kế trải nghiệm người dùng và giao diện người dùng'),
('Machine Learning', 'Các khóa học về trí tuệ nhân tạo và học máy'),
('ReactJS', 'Khóa học chuyên sâu về phát triển web với ReactJS'),
('Marketing', 'Khóa học về chiến lược và kỹ năng marketing hiện đại'),
('Khoa học máy tính', ' Khóa học về các nền tảng kiến thức cơ bản của khoa học máy tính'),
('Lập trình Java', 'Khóa học về lập trình ngôn ngữ Java, một ngôn ngữ phổ biến và mạnh mẽ'),
('Python', 'Khóa học về ngôn ngữ lập trình Python, ngôn ngữ rất đa năng và dễ học.'),
('Thiết kế đồ họa', ' Khóa học về thiết kế đồ họa, bao gồm  Photoshop, Illustrator, ...'),
('Quản trị mạng', ' Khóa học về quản trị mạng,  cung cấp kiến thức về bảo mật mạng, cấu hình hệ thống mạng'),
('Kinh doanh trực tuyến', 'Khóa học về các kỹ năng kinh doanh trực tuyến, e-commerce, marketing online'),
('SEO', 'Khóa học về tối ưu hóa công cụ tìm kiếm (SEO), giúp website của bạn được xếp hạng cao hơn trên Google'),
('Tiếng Anh giao tiếp', 'Khóa học về tiếng Anh giao tiếp, nâng cao khả năng giao tiếp tiếng Anh hiệu quả'),
('Kỹ năng mềm', ' Khóa học về kỹ năng mềm cần thiết cho công việc và cuộc sống, như kỹ năng giao tiếp, làm việc nhóm, giải quyết vấn đề'),
('Phát triển web', ' Khóa học về phát triển web, trang web động, ứng dụng web, ...'),
('Thương mại điện tử', 'Khóa học về thương mại điện tử, kinh doanh trực tuyến, marketing online, ...'),
('Quản trị dự án', 'Khóa học về quản lý dự án, kỹ năng lập kế hoạch, tổ chức, điều phối dự án'),
('Ngôn ngữ PHP', 'Khóa học về ngôn ngữ lập trình PHP, một ngôn ngữ phổ biến cho phát triển web'),
('Kiến trúc phần mềm', 'Khóa học về kiến trúc phần mềm, thiết kế và phát triển các hệ thống phần mềm lớn'),
('An ninh mạng',  'Khóa học về an ninh mạng, bảo mật thông tin, phòng chống tấn công mạng'),
('Phân tích dữ liệu nâng cao', 'Khóa học về phân tích dữ liệu nâng cao, sử dụng các công cụ và phần mềm phân tích dữ liệu'),
('Phát triển ứng dụng di động', 'Khóa học về phát triển ứng dụng di động, ứng dụng di động trên nền tảng Android, iOS'),
('Lập trình C++ cơ bản', 'Khóa học về lập trình C++ cơ bản, ngôn ngữ lập trình mạnh mẽ và phổ biến'),
('Khoa học dữ liệu với R', 'Khóa học về khoa học dữ liệu sử dụng ngôn ngữ lập trình R'),
('Thiết kế đồ họa với Illustrator', 'Khóa học về thiết kế đồ họa chuyên nghiệp với Illustrator');


--Giỏ hàng
SET IDENTITY_INSERT Cart ON;

INSERT INTO Cart (CartID)
VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(12),
(13),
(14),
(15),
(16),
(17),
(18),
(19),
(20);

SET IDENTITY_INSERT Cart OFF;

--Bảng khoá học
INSERT INTO Course (CourseName, CourseStatus, CourseDescription, CoursePrice, CourseImage, CourseStartDate, CourseEndDate, CategoryID)
VALUES
('Phân Tích Dữ Liệu với Python', 'Active', 'Khóa học về xử lý dữ liệu bằng Python', 1800000, 'data_analysis.jpg', '2024-02-01', '2024-03-15', 4),
('Phát triển UI/UX', 'Active', 'Khóa học thiết kế UI/UX chuyên nghiệp', 2500000, 'uiux_course.jpg', '2024-02-15', '2024-04-01', 5),
('Xây dựng ứng dụng ReactJS', 'Active', 'Khóa học ReactJS toàn diện', 2000000, 'reactjs_course.jpg', '2024-03-01', '2024-04-20', 6),
('Machine Learning Cơ Bản', 'Active', 'Khóa học cơ bản về trí tuệ nhân tạo', 3000000, 'ml_course.jpg', '2024-01-15', '2024-02-28', 7),
('Marketing hiện đại', 'Active', 'Chiến lược marketing mới nhất', 2200000, 'marketing_course.jpg', '2024-03-05', '2024-04-15', 8),
('Nền tảng Khoa học máy tính', 'Active', 'Khóa học cơ bản về kiến thức khoa học máy tính', 1500000, 'csfundamentals.jpg', '2024-04-01', '2024-05-15', 1),
('Lập trình Java nâng cao', 'Active', 'Khóa học chuyên sâu về kỹ thuật lập trình Java', 2800000, 'java_course.jpg', '2024-03-10', '2024-05-05', 2),
('Python cho Data Science', 'Active', 'Khóa học Python ứng dụng cho khoa học dữ liệu', 2500000, 'python_ds.jpg', '2024-04-10', '2024-05-20', 3),
('Thiết kế Web với Photoshop', 'Active', 'Khóa học thiết kế web với Photoshop chuyên nghiệp', 1800000, 'web_design_ps.jpg', '2024-02-20', '2024-04-10', 9),
('Quản trị mạng cơ bản', 'Active', 'Kiến thức cơ bản về mạng máy tính', 1200000, 'networking_basics.jpg', '2024-03-25', '2024-05-10', 10),
('Kinh doanh Online hiệu quả', 'Active', 'Kỹ năng kinh doanh thành công trên mạng', 2000000, 'ecommerce_course.jpg', '2024-04-05', '2024-05-25', 11),
('Tối ưu hóa công cụ tìm kiếm (SEO)', 'Active', 'Nâng cao thứ hạng website trên Google', 2200000, 'seo_course.jpg', '2024-02-10', '2024-04-05', 12),
('Luôn tự tin giao tiếp tiếng Anh', 'Active', 'Kỹ năng giao tiếp tiếng Anh hiệu quả', 1800000, 'english_communication.jpg', '2024-03-15', '2024-05-01', 13),
('Kỹ năng mềm cho doanh nhân', 'Active', 'Nâng cao kỹ năng mềm cần thiết cho doanh nghiệp', 1500000, 'soft_skills_course.jpg', '2024-04-20', '2024-06-05', 14),
('Phát triển web Fullstack', 'Active', 'Khóa học phát triển web toàn diện từ front-end đến back-end', 3500000, 'fullstack_webdev.jpg', '2024-01-25', '2024-03-30', 15),
('Khoá học Javascript nâng cao', 'Active', 'Khóa học Javascript chuyên sâu về các kiến thức trong Javascript', 2800000, 'js_advanced.jpg', '2024-03-01', '2024-04-15', 16),
('Thương mại điện tử cơ bản', 'Active', 'Khóa học về thương mại điện tử cơ bản', 2000000, 'ecommerce_basics.jpg', '2024-04-10', '2024-05-25', 17),
('Quản lý dự án hiệu quả', 'Active', 'Khóa học về quản lý dự án chuyên sâu', 2500000, 'project_management.jpg', '2024-02-15', '2024-04-01', 18),
('Lập trình PHP cơ bản', 'Active', 'Khóa học về lập trình PHP cơ bản', 1800000, 'php_basics.jpg', '2024-03-20', '2024-05-05', 19),
('Kiến trúc phần mềm', 'Active', 'Khóa học về kiến trúc phần mềm', 2200000, 'software_architecture.jpg', '2024-04-05', '2024-05-20', 20),
('Phân tích dữ liệu nâng cao', 'Active', 'Khóa học nâng cao về phân tích dữ liệu', 3000000, 'advanced_data_analysis.jpg', '2024-05-01', '2024-06-15', 21),
('Phát triển ứng dụng di động', 'Active', 'Khóa học phát triển ứng dụng di động toàn diện', 3500000, 'mobile_app_dev.jpg', '2024-05-10', '2024-06-25', 22),
('Lập trình C++ cơ bản', 'Active', 'Khóa học về lập trình C++ cơ bản', 1800000, 'cpp_basics.jpg', '2024-05-20', '2024-07-05', 23),
('Khoa học dữ liệu với R', 'Active', 'Khóa học về khoa học dữ liệu sử dụng R', 2500000, 'data_science_r.jpg', '2024-06-01', '2024-07-15', 24),
('Thiết kế đồ họa với Illustrator', 'Active', 'Khóa học thiết kế đồ họa chuyên nghiệp với Illustrator', 2200000, 'illustrator_design.jpg', '2024-06-10', '2024-07-25', 25);



--Chương
INSERT INTO Chapter (CourseID, ChapterName)
VALUES
(4, 'Cơ bản về dữ liệu'),
(5, 'Tối ưu giao diện'),
(6, 'Cấu trúc cơ bản ReactJS'),
(7, 'Học máy cơ bản'),
(8, 'Chiến lược Marketing'),
(9, 'Quản lý chiến dịch'),
(10, 'Tương tác với người dùng'),
(11, 'Tạo thành phần ReactJS'),
(12, 'Thuật toán Machine Learning'),
(13, 'Xử lý dữ liệu nâng cao'),
(14, 'Phân tích dữ liệu thống kê'),
(15, 'Thiết kế giao diện người dùng'),
(16, 'Ứng dụng ReactJS thực tế'),
(17, 'Xây dựng mô hình học máy'),
(18, 'Phân tích thị trường'),
(19, 'Phân tích dữ liệu nâng cao'),
(20, 'Phát triển ứng dụng di động'),
(21, 'Lập trình C++ cơ bản'),
(22, 'Khoa học dữ liệu với R'),
(23, 'Thiết kế đồ họa với Illustrator'),
(24, 'Quản trị mạng cơ bản'),
(25, 'Kinh doanh Online hiệu quả');

--Tài liệu
INSERT INTO Document (CourseID, ChapterName, DocumentAuthor, DocumentTitle, DocumentSize, DocumentType, DocumentContent)
VALUES
(4, 'Cơ bản về dữ liệu', 'Le Hoang Nam', 'Giới thiệu về dữ liệu lớn', 500, 'PDF', 'big_data_intro.pdf'),
(5, 'Tối ưu giao diện', 'Nguyen Thi Hoa', 'Tips tối ưu UI/UX', 700, 'PDF', 'uiux_tips.pdf'),
(6, 'Cấu trúc cơ bản ReactJS', 'Pham Minh Tuan', 'ReactJS cơ bản', 900, 'PDF', 'react_basics.pdf'),
(7, 'Học máy cơ bản', 'Tran Van Cuong', 'Thuật toán cơ bản', 800, 'PDF', 'ml_basics.pdf'),
(8, 'Chiến lược Marketing', 'Do Ngoc Anh', 'Các chiến lược marketing mới nhất', 600, 'PDF', 'marketing_strategy.pdf'),
(9, 'Quản lý chiến dịch', 'Tran Ngoc Han', 'Hướng dẫn quản lý chiến dịch marketing', 550, 'PDF', 'marketing_campaign.pdf'),
(10, 'Tương tác với người dùng', 'Nguyen Van Tung', 'Tạo trải nghiệm tích cực cho người dùng', 650, 'PDF', 'user_interaction.pdf'),
(11, 'Tạo thành phần ReactJS', 'Le Minh Khai', 'Bí quyết tạo thành phần ReactJS hiệu quả', 850, 'PDF', 'react_components.pdf'),
(12, 'Thuật toán Machine Learning', 'Pham Van Hai', 'Phân tích và ứng dụng các thuật toán', 950, 'PDF', 'ml_algorithms.pdf'),
(13, 'Xử lý dữ liệu nâng cao', 'Do Thi Mai', 'Kỹ thuật xử lý dữ liệu nâng cao', 700, 'PDF', 'data_processing_advanced.pdf'),
(14, 'Phân tích dữ liệu thống kê', 'Nguyen Thanh Dat', 'Các phương pháp phân tích dữ liệu', 600, 'PDF', 'data_analysis_statistic.pdf'),
(15, 'Thiết kế giao diện người dùng', 'Le Thi Thu', 'Nguyên tắc thiết kế giao diện hiệu quả', 500, 'PDF', 'ui_design_principles.pdf'),
(16, 'Ứng dụng ReactJS thực tế', 'Tran Van Minh', 'Xây dựng ứng dụng web thực tế với ReactJS', 900, 'PDF', 'react_app_development.pdf'),
(17, 'Xây dựng mô hình học máy', 'Pham Thi Hong', 'Hướng dẫn xây dựng mô hình học máy', 800, 'PDF', 'ml_model_building.pdf'),
(18, 'Phân tích thị trường', 'Do Van Hung', 'Phát hiện xu hướng thị trường', 700, 'PDF', 'market_analysis.pdf');

--Bài học
INSERT INTO Lesson (LessonOrder, CourseID, ChapterName, LessonTitle, LessonContent, LessonDuraion)
VALUES
(1, 4, 'Cơ bản về dữ liệu', 'Giới thiệu về dữ liệu lớn', 'Bài học tổng quan', '01:00:00'),
(2, 4, 'Cơ bản về dữ liệu', 'Xử lý dữ liệu cơ bản', 'Các bước xử lý dữ liệu', '01:30:00'),
(1, 5, 'Tối ưu giao diện', 'Thiết kế UI', 'Tối ưu màu sắc giao diện', '00:45:00'),
(2, 5, 'Tối ưu giao diện', 'Tương tác người dùng', 'Cải thiện UX', '01:15:00'),
(1, 6, 'Cấu trúc cơ bản ReactJS', 'Component đầu tiên', 'Tạo component đầu tiên', '00:30:00');

--Bài tập
INSERT INTO Exercise (ExerciseOrder, LessonOrder, CourseID, ChapterName, ExerciseTitle, ExerciseAnswer, ExerciseCorrectAnswerNumber, ExerciseContent)
VALUES
(1, 1, 4, 'Cơ bản về dữ liệu', 'Xử lý chuỗi JSON', 'Sử dụng JSON.parse()', 1, 'Xử lý file JSON từ API'),
(2, 2, 4, 'Cơ bản về dữ liệu', 'Phân tích dữ liệu CSV', 'Sử dụng pandas', 1, 'Phân tích file CSV mẫu'),
(1, 1, 5, 'Tối ưu giao diện', 'Chọn màu UI', 'Sử dụng bảng màu', 1, 'Chọn màu phù hợp cho giao diện'),
(2, 1, 6, 'Cấu trúc cơ bản ReactJS', 'Tạo Component', 'Sử dụng React.createElement()', 1, 'Tạo một component đơn giản');
















