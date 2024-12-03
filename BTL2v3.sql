
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

--Người đại diện
CREATE TABLE Guardian(
    GuardianID INT IDENTITY (1,1) PRIMARY KEY,
    StudentID INT,
    GuardianName VARCHAR(255),
    GuardianEmail VARCHAR(255),
    GuardianPhone VARCHAR(10),
)

--Bảng Chỉnh sửa
CREATE TABLE Edit (
    EditID INT IDENTITY (1,1) PRIMARY KEY,
    EditTime TIME,
    EditDescription VARCHAR(255),
    EditAdminID INT,
    EditCouponID INT,
    EditCourseID INT,
);

--Bảng Admin
CREATE TABLE Admin(
    AdminID INT IDENTITY (1,1) PRIMARY KEY,
);

--Bảng giảng viên
CREATE TABLE Teacher(
    TeacherID INT IDENTITY (1,1) PRIMARY KEY,
    TeacherDescription VARCHAR(255),
)

--Bảng học viên
CREATE TABLE Student(
    StudentID INT IDENTITY (1,1) PRIMARY KEY,
    CardID INT,
    OptionName VARCHAR(255),
    QuestionID INT,
)

--Giỏ hàng
CREATE TABLE Cart(
    CartID INT IDENTITY (1,1) PRIMARY KEY,
);

--Đơn hàng
CREATE TABLE Orders(
    OrderID INT IDENTITY (1,1) PRIMARY KEY,
    OrderPaymentStatus VARCHAR(255),
    OrderDate DATE,
    OrderPaymentCode VARCHAR(255),
    StudentID INT,
)

--Bảng danh mục
CREATE TABLE Category(
    CategoryID INT IDENTITY (1,1) PRIMARY KEY,
    CategoryName VARCHAR(255),
    CategoryDescription VARCHAR(255),
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
);

--Giảng viên dạy khoá học
CREATE TABLE TeacherCourse(
    TeacherID INT,
    CourseID INT,
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

--Phiếu giảm giá thuộc giỏ hàng
CREATE TABLE CouponCart(
    CouponID INT,
    CartID INT,
)

--Khoá học thuộc giỏ hàng
CREATE TABLE CourseCart(
    CourseID INT,
    CartID INT,
)

--Khoá học có học viên
CREATE TABLE CourseStudent(
    CourseID INT,
    StudentID INT,
)

--Khoá học thêm vào đơn hàng
CREATE TABLE CourseOrder(
    CourseID INT,
    OrderID INT,
)

--Đánh giá
CREATE TABLE Review(
    ReviewID INT IDENTITY (1,1) PRIMARY KEY,
    CourseID INT,
    ReviewScore INT,
    ReviewContent VARCHAR(255),
    StudentID INT,
)

--Phương thức thanh toán
CREATE TABLE PaymentMethod(
    PaymentCode VARCHAR(255) PRIMARY KEY, --mã thanh toán
    PayerName VARCHAR(255),
    PaymentDate DATE,
)

--Momo
CREATE TABLE Momo(
    PaymentCode VARCHAR(255), --mã thanh toán
    PhoneNumber VARCHAR(10),
)

--Internet Banking
CREATE TABLE InternetBanking(
    PaymentCode VARCHAR(255), --mã thanh toán
    BankName VARCHAR(255),
)

--VISA
CREATE TABLE VISA(
    PaymentCode VARCHAR(255), --mã thanh toán
    CardNumber VARCHAR(16),
    ExpireDate DATE,
)


--Chương
CREATE TABLE Chapter(
    ChapterName VARCHAR(255),
    CourseID INT,
)

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
)

--Bài học
CREATE TABLE Lesson(
    LessonOrder INT,
    CourseID INT,
    ChapterName VARCHAR(255),
    LessonTitle VARCHAR(255),
    LessonContent VARCHAR(255),
    LessonDuraion TIME,
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
)

--Bài kiểm tra
CREATE TABLE Test(
    TestOrder INT,
    CourseID INT,
    ChapterName VARCHAR(255),
    TestDuration TIME,
)

--Câu hỏi
CREATE TABLE Question(
    QuestionID INT IDENTITY (1,1) PRIMARY KEY,
    QuestionScore INT,
    QuestionContent VARCHAR(255),
)

--Câu hỏi thuộc bài kiểm tra
CREATE TABLE QuestionTest(
    QuestionID INT,
    TestOrder INT,
    CourseID INT,
    ChapterName VARCHAR(255),
)

--Lựa chọn

CREATE TABLE Options(
    QuestionID INT,
    OptionName VARCHAR(255), --Tên lựa chọn
    IsCorrect BIT, --Đúng hay sai
    OptionContent VARCHAR(255), --Nội dung lựa chọn
)