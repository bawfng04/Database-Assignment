
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