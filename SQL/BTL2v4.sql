
---------------------- TẠO DATABASE --------------------------------

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
	CourseAverageRating FLOAT,
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
    OptionName NVARCHAR(255),
    QuestionID INT,
    FOREIGN KEY (StudentID) REFERENCES Users(UsernameID),
    FOREIGN KEY (OptionName) REFERENCES Options(OptionName),
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID),
)
CREATE TABLE Student_Test(
    StudentID INT,
    CourseID INT,
    TestOrder INT,
    ChapterName NVARCHAR(255),
    TestScore FLOAT,  -- Điểm số của sinh viên cho bài kiểm tra
    -- Khóa chính gồm 4 trường
    PRIMARY KEY (StudentID, CourseID, TestOrder, ChapterName),
    -- Khóa ngoại tới bảng Student
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    -- Khóa ngoại tới bảng Test (gồm 3 trường CourseID, TestOrder, ChapterName)
    FOREIGN KEY (TestOrder, CourseID, ChapterName)
        REFERENCES Test(TestOrder, CourseID, ChapterName)
);
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



--Khoá học có học viên
CREATE TABLE CourseStudent(
    CourseID INT,
    StudentID INT,

    PRIMARY KEY (CourseID, StudentID),
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

--bảng review
CREATE TABLE Review(
    ReviewID INT,
    CourseID INT,
    ReviewScore INT,
    ReviewContent NVARCHAR(255),
    StudentID INT,
    PRIMARY KEY(ReviewID, CourseID),  -- Review là thực thể yếu của Course nên khóa chính gồm ReviewID và CourseID
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
);




------------ INSERT/UPDATE/DELETE - PROCEDURE/FUNCTION/TRIGGER ----------------










