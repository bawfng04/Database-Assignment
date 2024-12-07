
---------------------- TẠO DATABASE --------------------------------
USE Course
--Người dùng hệ thống
CREATE TABLE Users(
    UsernameID INT IDENTITY (1,1) PRIMARY KEY,
    UserEmail NVARCHAR(255),
    UserPhone VARCHAR(10),
    UserPassword NVARCHAR(255),
    UserAddress NVARCHAR(255),
    UserImage NVARCHAR(255),
    Username NVARCHAR(255),
)

--Bảng Admin
CREATE TABLE Admin(
    AdminID INT PRIMARY KEY,
    FOREIGN KEY (AdminID) REFERENCES Users(UsernameID),
);

--Bảng giảng viên
CREATE TABLE Teacher(
    TeacherID INT PRIMARY KEY,
    TeacherDescription NVARCHAR(255),

    FOREIGN KEY (TeacherID) REFERENCES Users(UsernameID),
)

--Bảng danh mục
CREATE TABLE Category(
    CategoryID INT IDENTITY (1,1) PRIMARY KEY,
    CategoryName NVARCHAR(255),
    CategoryDescription NVARCHAR(255),
);


--Giỏ hàng
CREATE TABLE Cart(
    CartID INT IDENTITY (1,1) PRIMARY KEY,
);


--Bảng khoá học
CREATE TABLE Course(
    CourseID INT IDENTITY (1,1) PRIMARY KEY,
    CourseName NVARCHAR(255),
    CourseStatus NVARCHAR(255),
    CourseDescription NVARCHAR(255),
    CoursePrice INT,
    CourseImage NVARCHAR(255),
    CourseStartDate DATE,
    CourseEndDate DATE,
    CategoryID INT,

    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
);


--Chương
CREATE TABLE Chapter(
    ChapterName NVARCHAR(255),
    CourseID INT,

    PRIMARY KEY (ChapterName, CourseID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

--Tài liệu
CREATE TABLE Document(
    DocumentID INT IDENTITY (1,1) PRIMARY KEY,
    CourseID INT,
    ChapterName NVARCHAR(255),
    DocumentAuthor NVARCHAR(255),
    DocumentTitle NVARCHAR(255),
    DocumentSize INT,
    DocumentType NVARCHAR(255),
    DocumentContent NVARCHAR(255),

    FOREIGN KEY (ChapterName, CourseID) REFERENCES Chapter(ChapterName, CourseID)
);

--Bài học
CREATE TABLE Lesson(
    LessonOrder INT,
    CourseID INT,
    ChapterName NVARCHAR(255),
    LessonTitle NVARCHAR(255),
    LessonContent NVARCHAR(255),
    LessonDuraion TIME,

    PRIMARY KEY (LessonOrder, CourseID, ChapterName),
    FOREIGN KEY (ChapterName, CourseID) REFERENCES Chapter(ChapterName, CourseID),
)

--Bài tập
CREATE TABLE Exercise(
    ExerciseOrder INT,
    LessonOrder INT,
    CourseID INT,
    ChapterName NVARCHAR(255),
    ExerciseTitle NVARCHAR(255),
    ExerciseAnswer NVARCHAR(255),
    ExerciseCorrectAnswerNumber INT,
    ExerciseContent NVARCHAR(255),

    PRIMARY KEY (ExerciseOrder, LessonOrder, CourseID, ChapterName),

    FOREIGN KEY (LessonOrder, CourseID, ChapterName) REFERENCES Lesson(LessonOrder, CourseID, ChapterName),
)

--Bài kiểm tra
CREATE TABLE Test(
    TestOrder INT,
    CourseID INT,
    ChapterName NVARCHAR(255),
    TestDuration TIME,

    PRIMARY KEY (TestOrder, CourseID, ChapterName),
    FOREIGN KEY (ChapterName, CourseID) REFERENCES Chapter(ChapterName, CourseID),
)

--Câu hỏi
CREATE TABLE Question(
    QuestionID INT IDENTITY (1,1) PRIMARY KEY,
    QuestionScore INT,
    QuestionContent NVARCHAR(255),
)

--Lựa chọn
CREATE TABLE Options(
    QuestionID INT,
    OptionName NVARCHAR(255) UNIQUE,
    IsCorrect BIT, --Đúng hay sai
    OptionContent NVARCHAR(255), --Nội dung lựa chọn

    PRIMARY KEY (QuestionID, OptionName),
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID),
)

--Câu hỏi thuộc bài kiểm tra
CREATE TABLE QuestionTest(
    QuestionID INT,
    TestOrder INT,
    CourseID INT,
    ChapterName NVARCHAR(255),

    PRIMARY KEY (QuestionID, TestOrder, CourseID, ChapterName),
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID),
    FOREIGN KEY (TestOrder, CourseID, ChapterName) REFERENCES Test(TestOrder, CourseID, ChapterName),
)

--Bảng học viên
CREATE TABLE Student(
    StudentID INT IDENTITY (1,1) PRIMARY KEY,
    CartID INT,
    OptionName NVARCHAR(255),
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
    GuardianName NVARCHAR(255),
    GuardianEmail NVARCHAR(255),
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
    CouponTitle NVARCHAR(255),
    CouponValue INT,
    CouponType NVARCHAR(255),
    CouponStartDate DATE,
    CouponExpire DATE,
    CouponMaxDiscount INT,
)

--Bảng Chỉnh sửa
CREATE TABLE Edit (
    EditID INT IDENTITY (1,1) PRIMARY KEY,
    EditTime TIME,
    EditDescription NVARCHAR(255),
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
    ReviewContent NVARCHAR(255),
    StudentID INT,

    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
)

--Phương thức thanh toán
CREATE TABLE PaymentMethod(
    PaymentCode NVARCHAR(255) PRIMARY KEY, --mã thanh toán
    PayerName NVARCHAR(255),
    PaymentDate DATE,
)

--Momo
CREATE TABLE Momo(
    PaymentCode NVARCHAR(255) PRIMARY KEY, --mã thanh toán
    PhoneNumber VARCHAR(10),

    FOREIGN KEY (PaymentCode) REFERENCES PaymentMethod(PaymentCode),
)

--Internet Banking
CREATE TABLE InternetBanking(
    PaymentCode NVARCHAR(255) PRIMARY KEY, --mã thanh toán
    BankName NVARCHAR(255),

    FOREIGN KEY (PaymentCode) REFERENCES PaymentMethod(PaymentCode),
)

--VISA
CREATE TABLE VISA(
    PaymentCode NVARCHAR(255) PRIMARY KEY, --mã thanh toán
    CardNumber VARCHAR(16),
    ExpireDate DATE,

    FOREIGN KEY (PaymentCode) REFERENCES PaymentMethod(PaymentCode),
)


--Đơn hàng
CREATE TABLE Orders(
    OrderID INT IDENTITY (1,1) PRIMARY KEY,
    OrderPaymentStatus NVARCHAR(255),
    OrderDate DATE,
    OrderPaymentCode NVARCHAR(255),
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
(N'LeHoangNam@gmail.com', '0911002001', N'nam123', N'Da Nang', N'LeHoangNam.jpg', N'Le Hoang Nam'),
(N'DoNgocAnh@gmail.com', '0909998877', N'anh789', N'Hue', N'DoNgocAnh.jpg', N'Do Ngoc Anh'),
(N'NguyenMinhTri@gmail.com', '0988455623', N'tri456', N'Hai Phong', N'NguyenMinhTri.jpg', N'Nguyen Minh Tri'),
(N'PhanQuocDung@gmail.com', '0936781254', N'dung000', N'Ha Noi', N'PhanQuocDung.jpg', N'Phan Quoc Dung'),
(N'BuiKieuTrinh@gmail.com', '0923346789', N'trinh321', N'Ho Chi Minh', N'BuiKieuTrinh.jpg', N'Bui Kieu Trinh'),
(N'VoThiLan@gmail.com', '0945567892', N'lan999', N'Da Lat', N'VoThiLan.jpg', N'Vo Thi Lan'),
(N'NgoDucHoa@gmail.com', '0916789456', N'hoa222', N'Can Tho', N'NgoDucHoa.jpg', N'Ngo Duc Hoa'),
(N'DangGiaHuy@gmail.com', '0978854123', N'huy456', N'Nha Trang', N'DangGiaHuy.jpg', N'Dang Gia Huy'),
(N'NgoNgocMi@gmail.com', '0901234567', N'mi789', N'Quang Nam', N'NgoNgocMi.jpg', N'Ngo Ngoc Mi'),
(N'TranThiNhuY@gmail.com', '0987654321', N'y123', N'Quang Ngai', N'TranThiNhuY.jpg', N'Tran Thi Nhu Y'),
(N'DangMinhNhut@gmail.com', '0912345678', N'nhut456', N'Quang Tri', N'DangMinhNhut.jpg', N'Dang Minh Nhut'),
(N'LeVanTam@gmail.com', '0912345679', N'tam123', N'Da Nang', N'LeVanTam.jpg', N'Le Van Tam'),
(N'NguyenThiHoa@gmail.com', '0912345680', N'hoa123', N'Hue', N'NguyenThiHoa.jpg', N'Nguyen Thi Hoa'),
(N'TranVanBinh@gmail.com', '0912345681', N'binh123', N'Hai Phong', N'TranVanBinh.jpg', N'Tran Van Binh'),
(N'PhamThiLan@gmail.com', '0912345682', N'lan123', N'Ha Noi', N'PhamThiLan.jpg', N'Pham Thi Lan'),
(N'HoangVanSon@gmail.com', '0912345683', N'son123', N'Ho Chi Minh', N'HoangVanSon.jpg', N'Hoang Van Son'),
(N'LeThiMai@gmail.com', '0912345684', N'mai123', N'Da Lat', N'LeThiMai.jpg', N'Le Thi Mai'),
(N'NguyenVanHung@gmail.com', '0912345685', N'hung123', N'Can Tho', N'NguyenVanHung.jpg', N'Nguyen Van Hung'),
(N'TranThiThu@gmail.com', '0912345686', N'thu123', N'Nha Trang', N'TranThiThu.jpg', N'Tran Thi Thu'),
(N'PhamVanKhanh@gmail.com', '0912345687', N'khanh123', N'Quang Nam', N'PhamVanKhanh.jpg', N'Pham Van Khanh'),
(N'NguyenThiBich@gmail.com', '0912345688', N'bich123', N'Quang Ngai', N'NguyenThiBich.jpg', N'Nguyen Thi Bich'),
(N'TranVanMinh@gmail.com', '0912345689', N'minh123', N'Quang Tri', N'TranVanMinh.jpg', N'Tran Van Minh'),
(N'NguyenThiLan@gmail.com', '0912345690', N'lan123', N'Ha Noi', N'NguyenThiLan.jpg', N'Nguyen Thi Lan'),
(N'LeVanHung@gmail.com', '0912345691', N'hung123', N'Ho Chi Minh', N'LeVanHung.jpg', N'Le Van Hung'),
(N'PhamThiLinh@gmail.com', '0912345692', N'linh123', N'Da Nang', N'PhamThiLinh.jpg', N'Pham Thi Linh'),
(N'VoVanThanh@gmail.com', '0912345693', N'thanh123', N'Can Tho', N'VoVanThanh.jpg', N'Vo Van Thanh'),
(N'TruongThiMy@gmail.com', '0912345694', N'my123', N'Hue', N'TruongThiMy.jpg', N'Truong Thi My'),
(N'NguyenVanKhang@gmail.com', '0912345695', N'khang123', N'Binh Duong', N'NguyenVanKhang.jpg', N'Nguyen Van Khang'),
(N'PhanThiHuyen@gmail.com', '0912345696', N'huyen123', N'Vinh Long', N'PhanThiHuyen.jpg', N'Phan Thi Huyen'),
(N'DangVanTien@gmail.com', '0912345697', N'tien123', N'Bac Lieu', N'DangVanTien.jpg', N'Dang Van Tien'),
(N'HoangThiAnh@gmail.com', '0912345698', N'anh123', N'Dong Nai', N'HoangThiAnh.jpg', N'Hoang Thi Anh'),
(N'DuongVanLong@gmail.com', '0912345699', N'long123', N'Tay Ninh', N'DuongVanLong.jpg', N'Duong Van Long'),
(N'LeVanDat@gmail.com', '0912345700', N'dat123', N'An Giang', N'LeVanDat.jpg', N'Le Van Dat'),
(N'NguyenThiMai@gmail.com', '0912345701', N'mai123', N'Binh Thuan', N'NguyenThiMai.jpg', N'Nguyen Thi Mai'),
(N'PhamVanNam@gmail.com', '0912345702', N'nam123', N'Khanh Hoa', N'PhamVanNam.jpg', N'Pham Van Nam'),
(N'TranVanHieu@gmail.com', '0912345703', N'hieu123', N'Binh Phuoc', N'TranVanHieu.jpg', N'Tran Van Hieu'),
(N'VoThiNgoc@gmail.com', '0912345704', N'ngoc123', N'Cần Thơ', N'VoThiNgoc.jpg', N'Vo Thi Ngoc'),
(N'LuongVanTuan@gmail.com', '0912345705', N'tuan123', N'Quang Ninh', N'LuongVanTuan.jpg', N'Luong Van Tuan'),
(N'NguyenThiKim@gmail.com', '0912345706', N'kim123', N'Hai Phong', N'NguyenThiKim.jpg', N'Nguyen Thi Kim'),
(N'TranVanTien@gmail.com', '0912345707', N'tien123', N'Thua Thien Hue', N'TranVanTien.jpg', N'Tran Van Tien'),
(N'LeVanBinh@gmail.com', '0912345708', N'binh123', N'Long An', N'LeVanBinh.jpg', N'Le Van Binh');

--Bảng Admin
INSERT INTO Admin (AdminID)
VALUES
(1),
(2),
(3);

--Bảng giảng viên
INSERT INTO Teacher (TeacherID, TeacherDescription)
VALUES
(4, N'Giảng viên có 20 năm kinh nghiệm trong việc giảng dạy môn sinh học'),
(5, N'Có chứng chỉ TOEIC 900, 5 năm kinh nghiệm giảng dạy tiếng Anh'),
(6, N'Giảng viên có 10 năm kinh nghiệm trong việc giảng dạy môn toán'),
(7, N'Giải nhất cuộc thi Toán học quốc gia 2020'),
(8, N'Giảng viên chuyên ngành Toán học, từng giảng dạy tại trường Đại học Khoa học Tự nhiên'),
(9, N'Giảng viên tiếng Anh, có chứng chỉ IELTS 8.0, kinh nghiệm giảng dạy cho học sinh quốc tế'),
(10, N'Giảng viên Kinh tế, nghiên cứu chuyên sâu về thị trường chứng khoán'),
(11, N'Giảng viên Lịch sử, từng tham gia nhiều dự án nghiên cứu về văn hóa Việt Nam'),
(12, N'Giảng viên Hóa học, có kinh nghiệm giảng dạy thực hành trong phòng thí nghiệm'),
(13, N'Giảng viên Vật lý, từng đạt giải nhì cuộc thi Vật lý quốc gia cho sinh viên'),
(14, N'Giảng viên Tin học, chuyên gia về lập trình web và ứng dụng di động'),
(15, N'Giảng viên Ngữ văn, có nhiều năm kinh nghiệm chấm thi THPT Quốc gia'),
(16, N'Giảng viên Âm nhạc, nghệ sĩ guitar cổ điển, đã từng biểu diễn tại nhiều chương trình quốc tế'),
(17, N'Giảng viên Mỹ thuật, họa sĩ chuyên ngành hội họa, tác phẩm từng được triển lãm tại nhiều nước'),
(18, N'Giảng viên Thể dục, HLV thể hình, từng đạt giải nhất cuộc thi thể hình quốc gia'),
(19, N'Giảng viên Kỹ thuật, chuyên gia về cơ khí, từng tham gia nhiều dự án lớn về xây dựng'),
(20, N'Giảng viên Ngoại ngữ, có chứng chỉ TOEFL 100, từng giảng dạy tại trường Đại học Ngoại ngữ');

--Bảng danh mục
INSERT INTO Category (CategoryName, CategoryDescription)
VALUES
(N'Phân tích dữ liệu', N'Các khóa học về phân tích và xử lý dữ liệu lớn'),
(N'UI/UX Design', N'Khóa học về thiết kế trải nghiệm người dùng và giao diện người dùng'),
(N'Machine Learning', N'Các khóa học về trí tuệ nhân tạo và học máy'),
(N'ReactJS', N'Khóa học chuyên sâu về phát triển web với ReactJS'),
(N'Marketing', N'Khóa học về chiến lược và kỹ năng marketing hiện đại'),
(N'Khoa học máy tính', N'Khóa học về các nền tảng kiến thức cơ bản của khoa học máy tính'),
(N'Lập trình Java', N'Khóa học về lập trình ngôn ngữ Java, một ngôn ngữ phổ biến và mạnh mẽ'),
(N'Python', N'Khóa học về ngôn ngữ lập trình Python, ngôn ngữ rất đa năng và dễ học'),
(N'Thiết kế đồ họa', N'Khóa học về thiết kế đồ họa, bao gồm Photoshop, Illustrator'),
(N'Quản trị mạng', N'Khóa học về quản trị mạng, cung cấp kiến thức về bảo mật mạng, cấu hình hệ thống mạng'),
(N'Kinh doanh trực tuyến', N'Khóa học về các kỹ năng kinh doanh trực tuyến, e-commerce, marketing online'),
(N'SEO', N'Khóa học về tối ưu hóa công cụ tìm kiếm (SEO), giúp website của bạn được xếp hạng cao hơn trên Google'),
(N'Tiếng Anh giao tiếp', N'Khóa học về tiếng Anh giao tiếp, nâng cao khả năng giao tiếp tiếng Anh hiệu quả'),
(N'Kỹ năng mềm', N'Khóa học về kỹ năng mềm cần thiết cho công việc và cuộc sống'),
(N'Phát triển web', N'Khóa học về phát triển web, trang web động, ứng dụng web'),
(N'Thương mại điện tử', N'Khóa học về thương mại điện tử, kinh doanh trực tuyến'),
(N'Quản trị dự án', N'Khóa học về quản lý dự án, kỹ năng lập kế hoạch, tổ chức'),
(N'Ngôn ngữ PHP', N'Khóa học về ngôn ngữ lập trình PHP'),
(N'Kiến trúc phần mềm', N'Khóa học về kiến trúc phần mềm, thiết kế và phát triển'),
(N'An ninh mạng', N'Khóa học về an ninh mạng, bảo mật thông tin'),
(N'Phân tích dữ liệu nâng cao', N'Khóa học về phân tích dữ liệu nâng cao'),
(N'Phát triển ứng dụng di động', N'Khóa học về phát triển ứng dụng di động'),
(N'Lập trình C++ cơ bản', N'Khóa học về lập trình C++ cơ bản'),
(N'Khoa học dữ liệu với R', N'Khóa học về khoa học dữ liệu sử dụng R'),
(N'Thiết kế đồ họa với Illustrator', N'Khóa học thiết kế đồ họa chuyên nghiệp với Illustrator');

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
(N'Phân Tích Dữ Liệu với Python', N'Active', N'Khóa học toàn diện về xử lý và phân tích dữ liệu sử dụng Python', 1800000, N'data_analysis.jpg', '2024-02-01', '2024-03-15', 1),
(N'Phát triển UI/UX Chuyên Nghiệp', N'Active', N'Khóa học thiết kế UI/UX từ cơ bản đến nâng cao', 2500000, N'uiux_course.jpg', '2024-02-15', '2024-04-01', 2),
(N'Lập Trình ReactJS Thực Chiến', N'Active', N'Khóa học ReactJS từ zero đến hero', 2000000, N'reactjs_course.jpg', '2024-03-01', '2024-04-20', 4);
--Chương
INSERT INTO Chapter (CourseID, ChapterName)
VALUES
-- Chương cho khóa Phân Tích Dữ Liệu với Python
(1, N'Cơ bản về Python và Numpy'),
(1, N'Thao tác dữ liệu với Pandas'),
(1, N'Trực quan hóa dữ liệu với Matplotlib'),
(1, N'Phân tích dữ liệu nâng cao'),

-- Chương cho khóa UI/UX
(2, N'Nguyên lý thiết kế UI/UX'),
(2, N'Công cụ thiết kế Figma'),
(2, N'Thiết kế giao diện người dùng'),
(2, N'Tối ưu trải nghiệm người dùng'),

-- Chương cho khóa ReactJS
(3, N'Cơ bản về ReactJS'),
(3, N'Components và Props'),
(3, N'State và Lifecycle'),
(3, N'React Hooks');

--Tài liệu
INSERT INTO Document (CourseID, ChapterName, DocumentAuthor, DocumentTitle, DocumentSize, DocumentType, DocumentContent)
VALUES
-- Tài liệu cho Chương 1
(1, N'Cơ bản về Python và Numpy', N'Trần Văn An', N'Hướng dẫn cơ bản Python', 2500, N'PDF', N'python_basics.pdf'),
(1, N'Cơ bản về Python và Numpy', N'Nguyễn Thị Bình', N'Thực hành với Numpy', 1800, N'PDF', N'numpy_tutorial.pdf'),
(1, N'Cơ bản về Python và Numpy', N'Lê Hoàng Nam', N'Bài tập Python và Numpy', 1500, N'PDF', N'python_numpy_exercises.pdf'),

-- Tài liệu cho Chương 2
(1, N'Thao tác dữ liệu với Pandas', N'Phạm Văn Cường', N'Pandas cơ bản', 2200, N'PDF', N'pandas_basics.pdf'),
(1, N'Thao tác dữ liệu với Pandas', N'Đỗ Thị Dung', N'Xử lý dữ liệu với Pandas', 2800, N'PDF', N'data_processing_pandas.pdf'),
(1, N'Thao tác dữ liệu với Pandas', N'Vũ Minh Đức', N'Bài tập Pandas', 1600, N'PDF', N'pandas_exercises.pdf'),

-- Tài liệu cho khóa UI/UX
-- Tài liệu cho Chương 1
(2, N'Nguyên lý thiết kế UI/UX', N'Trần Thị Mai', N'Nguyên tắc thiết kế UI/UX', 3200, N'PDF', N'uiux_principles.pdf'),
(2, N'Nguyên lý thiết kế UI/UX', N'Nguyễn Văn Hoàng', N'Color Theory trong UI/UX', 2500, N'PDF', N'color_theory.pdf'),
(2, N'Nguyên lý thiết kế UI/UX', N'Lê Thị Hương', N'Typography trong UI/UX', 1800, N'PDF', N'typography_guide.pdf'),

-- Tài liệu cho Chương 2
(2, N'Công cụ thiết kế Figma', N'Phạm Minh Tuấn', N'Hướng dẫn Figma cơ bản', 2800, N'PDF', N'figma_basics.pdf'),
(2, N'Công cụ thiết kế Figma', N'Đỗ Văn Nam', N'Thực hành Figma', 3000, N'PDF', N'figma_practice.pdf'),
(2, N'Công cụ thiết kế Figma', N'Vũ Thị Lan', N'Các thủ thuật trong Figma', 2200, N'PDF', N'figma_tips_tricks.pdf'),

-- Tài liệu cho khóa ReactJS
-- Tài liệu cho Chương 1
(3, N'Cơ bản về ReactJS', N'Nguyễn Văn Hiệu', N'Giới thiệu ReactJS', 2500, N'PDF', N'react_introduction.pdf'),
(3, N'Cơ bản về ReactJS', N'Trần Minh Đức', N'JSX và Components', 2800, N'PDF', N'jsx_components.pdf'),
(3, N'Cơ bản về ReactJS', N'Lê Văn Tùng', N'Bài tập React cơ bản', 2000, N'PDF', N'react_exercises.pdf'),

-- Tài liệu cho Chương 2
(3, N'Components và Props', N'Phạm Thị Thảo', N'React Components', 3000, N'PDF', N'react_components.pdf'),
(3, N'Components và Props', N'Đỗ Minh Quân', N'Props và State', 2700, N'PDF', N'props_state.pdf'),
(3, N'Components và Props', N'Vũ Hoàng Long', N'Thực hành Components', 2400, N'PDF', N'components_practice.pdf');

--Bài học
INSERT INTO Lesson (LessonOrder, CourseID, ChapterName, LessonTitle, LessonContent, LessonDuraion)
VALUES
-- Bài học cho khóa Python - Chương 1
(1, 1, N'Cơ bản về Python và Numpy', N'Giới thiệu về Python', N'Tổng quan về ngôn ngữ lập trình Python', '01:30:00'),
(2, 1, N'Cơ bản về Python và Numpy', N'Cấu trúc dữ liệu trong Python', N'List, Tuple, Dictionary và Set', '02:00:00'),
(3, 1, N'Cơ bản về Python và Numpy', N'Numpy cơ bản', N'Làm việc với mảng trong Numpy', '01:45:00'),

-- Bài học cho khóa Python - Chương 2
(1, 1, N'Thao tác dữ liệu với Pandas', N'Giới thiệu Pandas', N'Cơ bản về thư viện Pandas', '01:30:00'),
(2, 1, N'Thao tác dữ liệu với Pandas', N'DataFrame và Series', N'Làm việc với DataFrame và Series', '02:00:00'),

-- Bài học cho khóa UI/UX - Chương 1
(1, 2, N'Nguyên lý thiết kế UI/UX', N'Các nguyên tắc cơ bản', N'Nguyên tắc thiết kế UI/UX', '01:00:00'),
(2, 2, N'Nguyên lý thiết kế UI/UX', N'Color Theory', N'Lý thuyết màu sắc trong thiết kế', '01:30:00'),

-- Bài học cho khóa ReactJS - Chương 1
(1, 3, N'Cơ bản về ReactJS', N'Giới thiệu ReactJS', N'Tổng quan về ReactJS và JSX', '01:00:00'),
(2, 3, N'Cơ bản về ReactJS', N'Cài đặt môi trường', N'Cài đặt NodeJS và Create React App', '00:45:00');

--Bài tập
INSERT INTO Exercise (ExerciseOrder, LessonOrder, CourseID, ChapterName, ExerciseTitle, ExerciseAnswer, ExerciseCorrectAnswerNumber, ExerciseContent)
VALUES
-- Bài tập cho khóa Python - Chương 1, Bài 1
(1, 1, 1, N'Cơ bản về Python và Numpy', N'Biến trong Python', N'number = 10', 1, N'Khai báo một biến số nguyên có giá trị 10'),
(2, 1, 1, N'Cơ bản về Python và Numpy', N'Chuỗi trong Python', N'text = "Hello"', 1, N'Khai báo một biến chuỗi có giá trị "Hello"'),

-- Bài tập cho khóa Python - Chương 1, Bài 2
(1, 2, 1, N'Cơ bản về Python và Numpy', N'List trong Python', N'numbers = [1,2,3,4,5]', 1, N'Tạo một list chứa các số từ 1 đến 5'),
(2, 2, 1, N'Cơ bản về Python và Numpy', N'Dictionary trong Python', N'person = {"name": "John"}', 1, N'Tạo dictionary chứa thông tin tên'),

-- Bài tập cho khóa UI/UX - Chương 1, Bài 1
(1, 1, 2, N'Nguyên lý thiết kế UI/UX', N'Nguyên tắc căn chỉnh', N'Sử dụng lưới để căn chỉnh', 1, N'Thực hành căn chỉnh các phần tử trên giao diện'),
(2, 1, 2, N'Nguyên lý thiết kế UI/UX', N'Độ tương phản', N'Tạo độ tương phản rõ ràng', 1, N'Thực hành về độ tương phản trong thiết kế'),

-- Bài tập cho khóa ReactJS - Chương 1, Bài 1
(1, 1, 3, N'Cơ bản về ReactJS', N'JSX cơ bản', N'return <div>Hello World</div>', 1, N'Tạo component React đơn giản hiển thị Hello World'),
(2, 1, 3, N'Cơ bản về ReactJS', N'Components', N'function App() { return <div/> }', 1, N'Tạo một functional component trống');

SELECT * FROM Exercise



------------ INSERT/UPDATE/DELETE - PROCEDURE/FUNCTION/TRIGGER ----------------










