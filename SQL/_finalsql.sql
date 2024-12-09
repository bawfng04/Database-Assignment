
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












--------------- TRIGGER để check trước khi insert dữ liệu
-- Trigger khi insert dữ liệu vào bảng Users
GO
CREATE TRIGGER trg_Users_Insert
ON Users
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @UserEmail NVARCHAR(255), @UserPhone VARCHAR(10);

    SELECT @UserEmail = UserEmail, @UserPhone = UserPhone
    FROM inserted;

    -- Validate UserEmail
    IF @UserEmail IS NULL OR @UserEmail NOT LIKE '%_@__%.__%'
    BEGIN
        RAISERROR ('Invalid email format', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Validate UserPhone
    IF LEN(@UserPhone) <> 10 OR @UserPhone NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    BEGIN
        RAISERROR ('Invalid phone number', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Validate unique UserEmail
    IF EXISTS (SELECT 1 FROM Users WHERE UserEmail = @UserEmail)
    BEGIN
        RAISERROR ('UserEmail must be unique', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Validate unique UserPhone
    IF EXISTS (SELECT 1 FROM Users WHERE UserPhone = @UserPhone)
    BEGIN
        RAISERROR ('UserPhone must be unique', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- nếu không có lỗi thì insert dữ liệu
    INSERT INTO Users (UserEmail, UserPhone, UserPassword, UserAddress, UserImage, Username)
    SELECT UserEmail, UserPhone, UserPassword, UserAddress, UserImage, Username
    FROM inserted;
END;


--trigger cho bảng teacher
GO
CREATE TRIGGER trg_Teacher_Insert
ON Teacher
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @TeacherDescription NVARCHAR(255);

    SELECT @TeacherDescription = TeacherDescription
    FROM inserted;

    -- Validate TeacherDescription
    IF @TeacherDescription IS NULL
    BEGIN
        RAISERROR ('TeacherDescription cannot be null', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- nếu không có lỗi thì insert dữ liệu
    INSERT INTO Teacher (TeacherID, TeacherDescription)
    SELECT TeacherID, TeacherDescription
    FROM inserted;
END;


-- Trigger khi insert dữ liệu vào bảng Admin
GO
CREATE TRIGGER trg_Admin_Insert
ON Admin
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @AdminID INT;

    SELECT @AdminID = AdminID
    FROM inserted;

    -- Validate AdminID exists in Users table
    IF NOT EXISTS (SELECT 1 FROM Users WHERE UsernameID = @AdminID)
    BEGIN
        RAISERROR ('AdminID does not exist in Users table', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- If validation passes, insert the data
    INSERT INTO Admin (AdminID)
    SELECT AdminID
    FROM inserted;
END;


-- Trigger khi insert dữ liệu vào bảng Student
GO
CREATE TRIGGER trg_Student_Insert
ON Student
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @OptionName NVARCHAR(255), @QuestionID INT, @StudentID INT;

    SELECT @OptionName = OptionName, @QuestionID = QuestionID, @StudentID = StudentID
    FROM inserted;

    -- Validate OptionName
    IF @OptionName IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Options WHERE OptionName = @OptionName)
    BEGIN
        RAISERROR ('OptionName does not exist in Options table', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Validate QuestionID
    IF @QuestionID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Question WHERE QuestionID = @QuestionID)
    BEGIN
        RAISERROR ('QuestionID does not exist in Question table', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- If validation passes, insert the data
    INSERT INTO Student (StudentID, OptionName, QuestionID)
    SELECT StudentID, OptionName, QuestionID
    FROM inserted;
END;
GO


-- Trigger khi insert dữ liệu vào bảng Category
GO
CREATE TRIGGER trg_Category_Insert
ON Category
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @CategoryName NVARCHAR(255), @CategoryDescription NVARCHAR(255);

    SELECT @CategoryName = CategoryName, @CategoryDescription = CategoryDescription
    FROM inserted;

    -- Validate CategoryName
    IF @CategoryName IS NULL
    BEGIN
        RAISERROR ('CategoryName cannot be null', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Validate CategoryDescription
    IF @CategoryDescription IS NULL
    BEGIN
        RAISERROR ('CategoryDescription cannot be null', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- If validation passes, insert the data
    INSERT INTO Category (CategoryName, CategoryDescription)
    SELECT CategoryName, CategoryDescription
    FROM inserted;
END;




-- Trigger khi insert dữ liệu vào bảng Course
GO
CREATE TRIGGER trg_Course_Insert
ON Course
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @CourseName NVARCHAR(255), @CourseStatus NVARCHAR(255), @CourseDescription NVARCHAR(255),
            @CoursePrice INT, @CourseImage NVARCHAR(255), @CourseStartDate DATE, @CourseEndDate DATE,
            @CategoryID INT;

    SELECT @CourseName = CourseName, @CourseStatus = CourseStatus, @CourseDescription = CourseDescription,
            @CoursePrice = CoursePrice, @CourseImage = CourseImage, @CourseStartDate = CourseStartDate,
            @CourseEndDate = CourseEndDate, @CategoryID = CategoryID
    FROM inserted;

    -- Validate CourseName
    IF @CourseName IS NULL
    BEGIN
        RAISERROR ('CourseName cannot be null', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Validate CourseStatus
    IF @CourseStatus IS NULL
    BEGIN
        RAISERROR ('CourseStatus cannot be null', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Validate CourseDescription
    IF @CourseDescription IS NULL
    BEGIN
        RAISERROR ('CourseDescription cannot be null', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Validate CoursePrice
    IF @CoursePrice IS NULL
    BEGIN
        RAISERROR ('CoursePrice cannot be null', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Validate CourseImage
    IF @CourseImage IS NULL
    BEGIN
        RAISERROR ('CourseImage cannot be null', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Validate CourseStartDate
    IF @CourseStartDate IS NULL
    BEGIN
        RAISERROR ('CourseStartDate cannot be null', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Validate CourseEndDate
    IF @CourseEndDate IS NULL
    BEGIN
        RAISERROR ('CourseEndDate cannot be null', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Validate CategoryID
    IF NOT EXISTS (SELECT 1 FROM Category WHERE CategoryID = @CategoryID)
    BEGIN
        RAISERROR ('CategoryID does not exist in Category table', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;

    END


    -- If validation passes, insert the data
    INSERT INTO Course (CourseName, CourseStatus, CourseDescription, CoursePrice, CourseImage, CourseStartDate, CourseEndDate, CategoryID)
    SELECT CourseName, CourseStatus, CourseDescription, CoursePrice, CourseImage, CourseStartDate, CourseEndDate, CategoryID
    FROM inserted;
END;



---------------------------------------- Dữ liệu mẫu ----------------------------------------

-- Insert Users
INSERT INTO Users (UserEmail, UserPhone, UserPassword, UserAddress, UserImage, Username) VALUES
-- Admins
('admin1@edu.com', '0123456789', 'admin123', N'Hà Nội', '/images/admin1.jpg', N'Admin Nguyễn Văn A'),
('admin2@edu.com', '0123456788', 'admin456', N'Hồ Chí Minh', '/images/admin2.jpg', N'Admin Trần Thị B'),

-- Teachers
('teacher1@edu.com', '0123456787', 'teacher123', N'Hà Nội', '/images/teacher1.jpg', N'GV. Phạm Văn C'),
('teacher2@edu.com', '0123456786', 'teacher456', N'Đà Nẵng', '/images/teacher2.jpg', N'GV. Lê Thị D'),
('teacher3@edu.com', '0123456785', 'teacher789', N'Hải Phòng', '/images/teacher3.jpg', N'GV. Hoàng Văn E'),
('teacher4@edu.com', '0123456784', 'teacher012', N'Cần Thơ', '/images/teacher4.jpg', N'GV. Ngô Thị F'),

-- Students (14 students)
('student1@gmail.com', '0123456783', 'student123', N'Hà Nội', '/images/student1.jpg', N'Trần Văn G'),
('student2@gmail.com', '0123456782', 'student456', N'Hồ Chí Minh', '/images/student2.jpg', N'Nguyễn Thị H'),
('student3@gmail.com', '0123456781', 'student789', N'Đà Nẵng', '/images/student3.jpg', N'Lê Văn I'),
('student4@gmail.com', '0123456780', 'student012', N'Hải Phòng', '/images/student4.jpg', N'Phạm Thị K'),
('student5@gmail.com', '0123456779', 'student345', N'Cần Thơ', '/images/student5.jpg', N'Hoàng Văn L'),
('student6@gmail.com', '0123456778', 'student678', N'Hà Nội', '/images/student6.jpg', N'Ngô Thị M'),
('student7@gmail.com', '0123456777', 'student901', N'Hồ Chí Minh', '/images/student7.jpg', N'Vũ Văn N'),
('student8@gmail.com', '0123456776', 'student234', N'Đà Nẵng', '/images/student8.jpg', N'Đặng Thị O'),
('student9@gmail.com', '0123456775', 'student567', N'Hải Phòng', '/images/student9.jpg', N'Bùi Văn P'),
('student10@gmail.com', '0123456774', 'student890', N'Cần Thơ', '/images/student10.jpg', N'Mai Thị Q'),
('student11@gmail.com', '0123456773', 'student111', N'Hà Nội', '/images/student11.jpg', N'Lý Văn R'),
('student12@gmail.com', '0123456772', 'student222', N'Hồ Chí Minh', '/images/student12.jpg', N'Trịnh Thị S'),
('student13@gmail.com', '0123456771', 'student333', N'Đà Nẵng', '/images/student13.jpg', N'Đinh Văn T'),
('student14@gmail.com', '0123456770', 'student444', N'Hải Phòng', '/images/student14.jpg', N'Cao Thị U');

-- Insert Admin
INSERT INTO Admin (AdminID) VALUES (1), (2);

-- Insert Teacher
INSERT INTO Teacher (TeacherID, TeacherDescription) VALUES
(3, N'Chuyên gia lập trình với 10 năm kinh nghiệm'),
(4, N'Thạc sĩ Khoa học máy tính'),
(5, N'Tiến sĩ An toàn thông tin'),
(6, N'Chuyên gia về AI và Machine Learning');

-- Insert Category
INSERT INTO Category (CategoryName, CategoryDescription) VALUES
(N'Lập trình web', N'Các khóa học về phát triển web'),
(N'Lập trình mobile', N'Các khóa học về phát triển ứng dụng di động'),
(N'Cơ sở dữ liệu', N'Các khóa học về quản trị và thiết kế database'),
(N'AI và Machine Learning', N'Các khóa học về trí tuệ nhân tạo');

-- Insert Course
INSERT INTO Course (CourseName, CourseStatus, CourseDescription, CoursePrice, CourseImage, CourseStartDate, CourseEndDate, CategoryID) VALUES
(N'Lập trình Web với React', 'active', N'Khóa học toàn diện về React', 2000000, '/images/react.jpg', '2024-01-01', '2024-06-30', 1),
(N'Android Development', 'active', N'Phát triển ứng dụng Android', 2500000, '/images/android.jpg', '2024-01-15', '2024-07-15', 2),
(N'SQL Master', 'active', N'Làm chủ SQL Server', 1800000, '/images/sql.jpg', '2024-02-01', '2024-05-31', 3),
(N'Machine Learning Cơ bản', 'active', N'Nhập môn ML', 3000000, '/images/ml.jpg', '2024-02-15', '2024-08-15', 4);

-- Insert TeacherCourse
INSERT INTO TeacherCourse (TeacherID, CourseID) VALUES
(3, 1), (3, 2),
(4, 2), (4, 3),
(5, 3), (5, 4),
(6, 4), (6, 1);

-- Insert Student (assigning UsernameID 7-20 as students)
SET IDENTITY_INSERT Student ON;
INSERT INTO Student (StudentID, OptionName, QuestionID) VALUES
(7, NULL, NULL),
(8, NULL, NULL),
(9, NULL, NULL),
(10, NULL, NULL),
(11, NULL, NULL),
(12, NULL, NULL),
(13, NULL, NULL),
(14, NULL, NULL),
(15, NULL, NULL),
(16, NULL, NULL),
(17, NULL, NULL),
(18, NULL, NULL),
(19, NULL, NULL),
(20, NULL, NULL);
SET IDENTITY_INSERT Student OFF;
-- Insert PaymentMethod
INSERT INTO PaymentMethod (PaymentCode, PayerName, PaymentDate) VALUES
('PAY001', N'Trần Văn G', '2024-01-05'),
('PAY002', N'Nguyễn Thị H', '2024-01-10'),
('PAY003', N'Lê Văn I', '2024-01-15'),
('PAY004', N'Phạm Thị K', '2024-01-20'),
('PAY005', N'Hoàng Văn L', '2024-01-25');
-- Thêm dữ liệu cho Momo (2 giao dịch)
INSERT INTO Momo (PaymentCode, PhoneNumber) VALUES
('PAY001', '0123456783'),  -- Số điện thoại của student 7
('PAY002', '0123456782');  -- Số điện thoại của student 8

-- Thêm dữ liệu cho Internet Banking (2 giao dịch)
INSERT INTO InternetBanking (PaymentCode, BankName) VALUES
('PAY003', N'VietcomBank'),  -- Của student 9
('PAY004', N'BIDV');         -- Của student 10

-- Thêm dữ liệu cho VISA (1 giao dịch)
INSERT INTO VISA (PaymentCode, CardNumber, ExpireDate) VALUES
('PAY005', '4111111111111111', '2025-12-31');  -- Của student 11
-- Insert Coupon data
INSERT INTO Coupon (CouponTitle, CouponValue, CouponType, CouponStartDate, CouponExpire, CouponMaxDiscount) VALUES
-- Giảm theo phần trăm
(N'Giảm 15% khóa học mới', 15, N'Phần trăm', '2024-01-01', '2024-03-31', 500000),
(N'Giảm 25% khóa học IT', 25, N'Phần trăm', '2024-02-01', '2024-04-30', 1000000),
-- Giảm theo giá trị cố định
(N'Giảm 300k khóa học đầu tiên', 300000, N'Giá trị', '2024-01-15', '2024-03-15', 300000),
(N'Giảm 500k khóa học nâng cao', 500000, N'Giá trị', '2024-02-15', '2024-05-15', 500000);

-- Insert Orders
INSERT INTO Orders (OrderPaymentStatus, OrderDate, OrderPaymentCode, StudentID) VALUES
('paid', '2024-01-05', 'PAY001', 7), --đơn 1 của student 7
('paid', '2024-01-10', 'PAY002', 8), --đơn 2 của student 8
('paid', '2024-01-15', 'PAY003', 9),--đơn 3 của student 9
('paid', '2024-01-20', 'PAY004', 10),--đơn 4 của student 10
('paid', '2024-01-25', 'PAY005', 11), -- đơn 5 của student 11
('unpaid', '2024-02-01', NULL, 12),  -- đơn 6 học sinh 12
('unpaid', '2024-02-05', NULL, 13),  --đơn 7 học sinh 13
('unpaid', '2024-02-10', NULL, 14),  -- đơn 8 học sinh 14
('unpaid', '2024-02-15', NULL, 15),  -- đơn 9 học sinh 15
('unpaid', '2024-02-20', NULL, 16);  -- đơn 10 học sinh 16

-- Insert CourseOrder
INSERT INTO CourseOrder (CourseID, OrderID) VALUES
(1, 1), --đơn 1 course 1
(2, 1), -- đơn 1 course 2
(1, 2), -- đơn 2 course 1
(3, 2), -- đơn 2 course 3
(2, 3), -- đơn 3 course 2
(4, 3), -- đơn  3 course 4
(3, 4), -- đơn 4 course 3
(4, 5), -- đơn 5 course 4

(1, 6),  -- đơn 6 student 12 đăng ký course 1 (React)
(3, 6),  -- đơn 6 student 12 đăng ký course 3 (SQL)
(2, 7),  -- đơn 7 student 13 đăng ký course 2 (Android)
(4, 8),  -- đơn 8 student 14 đăng ký course 4 (ML)
(1, 9),  -- đơn 9 student 15 đăng ký course 1 (React)
(2, 9),  -- đơn 9 student 15 đăng ký course 2 (Android)
(4, 10); -- đơn 10 student 16 đăng ký course 4 (ML)

-- Insert CourseStudent (matching with Orders)
INSERT INTO CourseStudent (CourseID, StudentID) VALUES
(1, 7),  --student 7 có course 1
(2, 7),--student 7 có course 2
(1, 8), --student 8 course 1
(3, 8),--student 8 course 3
(2, 9),--student 9 course 2
(4, 9),--student 9 course 4
(3, 10),--student 10 course 3
(4, 11);--student 11 course 4


INSERT INTO Review (ReviewID, CourseID, ReviewScore, ReviewContent, StudentID) VALUES
-- Course 1 (React) - ReviewID phải khác nhau trong cùng CourseID
(1, 1, 5, N'Khóa học ReactJS rất hay và dễ hiểu', 7),        -- Student 7 review course 1 (React)
(2, 1, 5, N'Tuyệt vời, đã học được nhiều điều mới về React', 8),  -- Student 8 review course 1 (React)

-- Course 2 (Android)
(1, 2, 4, N'Giảng viên Android nhiệt tình, tài liệu đầy đủ', 7), -- Student 7 review course 2 (Android)
(2, 2, 5, N'Rất hài lòng với khóa học Android này', 9),          -- Student 9 review course 2 (Android)

-- Course 3 (SQL)
(1, 3, 4, N'Khóa học SQL rất thực tế và hữu ích', 8),            -- Student 8 review course 3 (SQL)
(2, 3, 5, N'Giảng viên SQL rất tâm huyết', 10),                 -- Student 10 review course 3 (SQL)

-- Course 4 (ML)
(1, 4, 4, N'Nội dung ML phong phú và chất lượng', 9),           -- Student 9 review course 4 (ML)
(2, 4, 5, N'Khóa học ML đáp ứng đúng nhu cầu', 11);            -- Student 11 review course 4 (ML)


INSERT INTO Chapter (ChapterName, CourseID) VALUES
(N'Chương 1: Giới thiệu về ReactJS', 1),          -- Chapter 1 của React
(N'Chương 2: JSX và Components', 1),              -- Chapter 2 của React
(N'Chương 3: State và Props', 1),                 -- Chapter 3 của React
(N'Chương 4: React Hooks', 1);                    -- Chapter 4 của React

-- Thêm Chapter cho Course 2 (Android)
INSERT INTO Chapter (ChapterName, CourseID) VALUES
(N'Chương 1: Cơ bản về Android', 2),             -- Chapter 1 của Android
(N'Chương 2: Layout và UI', 2),                  -- Chapter 2 của Android
(N'Chương 3: Activities và Intents', 2),         -- Chapter 3 của Android
(N'Chương 4: Data Storage', 2);                  -- Chapter 4 của Android

-- Thêm Chapter cho Course 3 (SQL)
INSERT INTO Chapter (ChapterName, CourseID) VALUES
(N'Chương 1: Cơ sở về SQL', 3),                  -- Chapter 1 của SQL
(N'Chương 2: Truy vấn cơ bản', 3),              -- Chapter 2 của SQL
(N'Chương 3: Joins và Subqueries', 3),          -- Chapter 3 của SQL
(N'Chương 4: Stored Procedures', 3);            -- Chapter 4 của SQL

-- Thêm Chapter cho Course 4 (ML)
INSERT INTO Chapter (ChapterName, CourseID) VALUES
(N'Chương 1: Giới thiệu Machine Learning', 4),   -- Chapter 1 của ML
(N'Chương 2: Supervised Learning', 4),           -- Chapter 2 của ML
(N'Chương 3: Unsupervised Learning', 4),        -- Chapter 3 của ML
(N'Chương 4: Deep Learning', 4);                -- Chapter 4 của ML
INSERT INTO Test (TestOrder, CourseID, ChapterName, TestDuration) VALUES
-- Tests for React Course (Course 1)
(1, 1, N'Chương 1: Giới thiệu về ReactJS', '00:30:00'),    -- Test 1 của Chương 1 Course React
(2, 1, N'Chương 1: Giới thiệu về ReactJS', '00:30:00'),    -- Test 2 của Chương 1 Course React

(1, 1, N'Chương 2: JSX và Components', '00:30:00'),        -- Test 1 của Chương 2 Course React
(2, 1, N'Chương 2: JSX và Components', '00:30:00'),        -- Test 2 của Chương 2 Course React

(1, 1, N'Chương 3: State và Props', '00:30:00'),           -- Test 1 của Chương 3 Course React
(2, 1, N'Chương 3: State và Props', '00:30:00'),           -- Test 2 của Chương 3 Course React

(1, 1, N'Chương 4: React Hooks', '00:30:00'),              -- Test 1 của Chương 4 Course React
(2, 1, N'Chương 4: React Hooks', '00:30:00'),              -- Test 2 của Chương 4 Course React

-- Tests for Android Course (Course 2)
(1, 2, N'Chương 1: Cơ bản về Android', '00:30:00'),        -- Test 1 của Chương 1 Course Android
(2, 2, N'Chương 1: Cơ bản về Android', '00:30:00'),        -- Test 2 của Chương 1 Course Android

(1, 2, N'Chương 2: Layout và UI', '00:30:00'),             -- Test 1 của Chương 2 Course Android
(2, 2, N'Chương 2: Layout và UI', '00:30:00'),             -- Test 2 của Chương 2 Course Android

(1, 2, N'Chương 3: Activities và Intents', '00:30:00'),    -- Test 1 của Chương 3 Course Android
(2, 2, N'Chương 3: Activities và Intents', '00:30:00'),    -- Test 2 của Chương 3 Course Android

(1, 2, N'Chương 4: Data Storage', '00:30:00'),             -- Test 1 của Chương 4 Course Android
(2, 2, N'Chương 4: Data Storage', '00:30:00'),             -- Test 2 của Chương 4 Course Android

-- Tests for SQL Course (Course 3)
(1, 3, N'Chương 1: Cơ sở về SQL', '00:30:00'),             -- Test 1 của Chương 1 Course SQL
(2, 3, N'Chương 1: Cơ sở về SQL', '00:30:00'),             -- Test 2 của Chương 1 Course SQL

(1, 3, N'Chương 2: Truy vấn cơ bản', '00:30:00'),          -- Test 1 của Chương 2 Course SQL
(2, 3, N'Chương 2: Truy vấn cơ bản', '00:30:00'),          -- Test 2 của Chương 2 Course SQL

(1, 3, N'Chương 3: Joins và Subqueries', '00:30:00'),      -- Test 1 của Chương 3 Course SQL
(2, 3, N'Chương 3: Joins và Subqueries', '00:30:00'),      -- Test 2 của Chương 3 Course SQL

(1, 3, N'Chương 4: Stored Procedures', '00:30:00'),        -- Test 1 của Chương 4 Course SQL
(2, 3, N'Chương 4: Stored Procedures', '00:30:00'),        -- Test 2 của Chương 4 Course SQL

-- Tests for ML Course (Course 4)
(1, 4, N'Chương 1: Giới thiệu Machine Learning', '00:30:00'), -- Test 1 của Chương 1 Course ML
(2, 4, N'Chương 1: Giới thiệu Machine Learning', '00:30:00'), -- Test 2 của Chương 1 Course ML

(1, 4, N'Chương 2: Supervised Learning', '00:30:00'),         -- Test 1 của Chương 2 Course ML
(2, 4, N'Chương 2: Supervised Learning', '00:30:00'),         -- Test 2 của Chương 2 Course ML

(1, 4, N'Chương 3: Unsupervised Learning', '00:30:00'),      -- Test 1 của Chương 3 Course ML
(2, 4, N'Chương 3: Unsupervised Learning', '00:30:00'),      -- Test 2 của Chương 3 Course ML

(1, 4, N'Chương 4: Deep Learning', '00:30:00'),              -- Test 1 của Chương 4 Course ML
(2, 4, N'Chương 4: Deep Learning', '00:30:00');              -- Test 2 của Chương 4 Course ML
INSERT INTO Question (QuestionScore, QuestionContent) VALUES
-- React Questions (1-5)
(2, N'React là gì?'),                                          -- Question 1
(2, N'JSX trong React là gì?'),                               -- Question 2
(2, N'Props trong React được sử dụng để làm gì?'),            -- Question 3
(2, N'State trong React là gì?'),                             -- Question 4
(2, N'React Hooks được giới thiệu từ phiên bản nào?'),        -- Question 5

-- Android Questions (6-10)
(2, N'Android Studio là gì?'),                                -- Question 6
(2, N'Layout trong Android là gì?'),                          -- Question 7
(2, N'Activity trong Android là gì?'),                        -- Question 8
(2, N'Intent trong Android được sử dụng để làm gì?'),         -- Question 9
(2, N'SQLite trong Android được sử dụng để làm gì?'),         -- Question 10

-- SQL Questions (11-15)
(2, N'Primary Key là gì?'),                                   -- Question 11
(2, N'JOIN trong SQL là gì?'),                               -- Question 12
(2, N'Stored Procedure là gì?'),                             -- Question 13
(2, N'Transaction trong SQL Server là gì?'),                 -- Question 14
(2, N'Index trong SQL Server dùng để làm gì?'),              -- Question 15

-- ML Questions (16-20)
(2, N'Machine Learning là gì?'),                             -- Question 16
(2, N'Supervised Learning là gì?'),                          -- Question 17
(2, N'Unsupervised Learning là gì?'),                        -- Question 18
(2, N'Deep Learning là gì?'),                                -- Question 19
(2, N'Neural Network là gì?');                               -- Question 20

-- Insert Options for each Question
INSERT INTO Options (QuestionID, OptionName, OptionContent, IsCorrect) VALUES
-- Options for Question 1 (React là gì?)
(1, 'A1', N'Một framework JavaScript', 0),
(1, 'B1', N'Một thư viện JavaScript để xây dựng giao diện người dùng', 1),
(1, 'C1', N'Một ngôn ngữ lập trình', 0),
(1, 'D1', N'Một cơ sở dữ liệu', 0),

-- Options for Question 2 (JSX trong React là gì?)
(2, 'A2', N'Một extension của JavaScript cho phép viết HTML trong JavaScript', 1),
(2, 'B2', N'Một ngôn ngữ lập trình mới', 0),
(2, 'C2', N'Một framework', 0),
(2, 'D2', N'Một thư viện độc lập', 0),

-- Options for Question 3 (Props trong React)
(3, 'A3', N'Để lưu trữ state của component', 0),
(3, 'B3', N'Để truyền dữ liệu giữa các component', 1),
(3, 'C3', N'Để tạo routing', 0),
(3, 'D3', N'Để kết nối database', 0),

-- Options for Question 4 (State trong React)
(4, 'A4', N'Dữ liệu tĩnh không thay đổi', 0),
(4, 'B4', N'Dữ liệu động có thể thay đổi trong component', 1),
(4, 'C4', N'Thuộc tính CSS', 0),
(4, 'D4', N'Tên component', 0),

-- Options for Question 5 (React Hooks)
(5, 'A5', N'React 15.0', 0),
(5, 'B5', N'React 16.8', 1),
(5, 'C5', N'React 17.0', 0),
(5, 'D5', N'React 18.0', 0),

-- Options for Question 6 (Android Studio là gì?)
(6, 'A6', N'IDE chính thức để phát triển ứng dụng Android', 1),
(6, 'B6', N'Một trình duyệt web', 0),
(6, 'C6', N'Một hệ điều hành', 0),
(6, 'D6', N'Một ngôn ngữ lập trình', 0),

-- Options for Question 7 (Layout trong Android là gì?)
(7, 'A7', N'Một dạng cơ sở dữ liệu', 0),
(7, 'B7', N'Cấu trúc sắp xếp các thành phần giao diện người dùng', 1),
(7, 'C7', N'Một kiểu biến trong Android', 0),
(7, 'D7', N'Một công cụ debug', 0),

-- Options for Question 8 (Activity trong Android là gì?)
(8, 'A8', N'Một file cấu hình', 0),
(8, 'B8', N'Một component đại diện cho một màn hình trong ứng dụng', 1),
(8, 'C8', N'Một thư viện đồ họa', 0),
(8, 'D8', N'Một loại database', 0),

-- Options for Question 9 (Intent trong Android)
(9, 'A9', N'Một cơ chế để chuyển đổi giữa các Activity', 1),
(9, 'B9', N'Một kiểu dữ liệu', 0),
(9, 'C9', N'Một framework testing', 0),
(9, 'D9', N'Một công cụ build', 0),

-- Options for Question 10 (SQLite trong Android)
(10, 'A10', N'Một framework UI', 0),
(10, 'B10', N'Một hệ quản trị cơ sở dữ liệu nhẹ tích hợp trong Android', 1),
(10, 'C10', N'Một công cụ debug', 0),
(10, 'D10', N'Một thư viện đồ họa', 0),

-- Options for Question 11 (Primary Key là gì?)
(11, 'A11', N'Khóa dùng để mở database', 0),
(11, 'B11', N'Trường duy nhất định danh cho mỗi bản ghi trong bảng', 1),
(11, 'C11', N'Một loại index', 0),
(11, 'D11', N'Một công cụ tối ưu', 0),

-- Options for Question 12 (JOIN trong SQL là gì?)
(12, 'A12', N'Lệnh để tạo bảng mới', 0),
(12, 'B12', N'Phương thức kết hợp dữ liệu từ nhiều bảng', 1),
(12, 'C12', N'Công cụ backup database', 0),
(12, 'D12', N'Một loại constraint', 0),

-- Options for Question 13 (Stored Procedure là gì?)
(13, 'A13', N'Một tập hợp các câu lệnh SQL được biên dịch sẵn', 1),
(13, 'B13', N'Một loại table', 0),
(13, 'C13', N'Một công cụ quản lý user', 0),
(13, 'D13', N'Một kiểu dữ liệu', 0),

-- Options for Question 14 (Transaction trong SQL Server)
(14, 'A14', N'Một công cụ backup', 0),
(14, 'B14', N'Một đơn vị công việc đảm bảo tính toàn vẹn dữ liệu', 1),
(14, 'C14', N'Một loại index', 0),
(14, 'D14', N'Một kiểu join', 0),

-- Options for Question 15 (Index trong SQL Server)
(15, 'A15', N'Một cấu trúc để tối ưu hóa truy vấn', 1),
(15, 'B15', N'Một loại bảng', 0),
(15, 'C15', N'Một công cụ backup', 0),
(15, 'D15', N'Một kiểu constraint', 0),

-- Options for Question 16 (Machine Learning là gì?)
(16, 'A16', N'Một ngôn ngữ lập trình', 0),
(16, 'B16', N'Khả năng máy tính học từ dữ liệu mà không cần lập trình tường minh', 1),
(16, 'C16', N'Một hệ điều hành', 0),
(16, 'D16', N'Một công cụ phần mềm', 0),

-- Options for Question 17 (Supervised Learning là gì?)
(17, 'A17', N'Học có giám sát với dữ liệu được gán nhãn', 1),
(17, 'B17', N'Học không giám sát', 0),
(17, 'C17', N'Học tăng cường', 0),
(17, 'D17', N'Deep Learning', 0),

-- Options for Question 18 (Unsupervised Learning là gì?)
(18, 'A18', N'Học có giám sát', 0),
(18, 'B18', N'Học không giám sát với dữ liệu không gán nhãn', 1),
(18, 'C18', N'Học tăng cường', 0),
(18, 'D18', N'Transfer Learning', 0),

-- Options for Question 19 (Deep Learning là gì?)
(19, 'A19', N'Một thuật toán Machine Learning', 0),
(19, 'B19', N'Một phương pháp học sâu sử dụng nhiều lớp neural network', 1),
(19, 'C19', N'Một công cụ phần mềm', 0),
(19, 'D19', N'Một ngôn ngữ lập trình', 0),

-- Options for Question 20 (Neural Network là gì?)
(20, 'A20', N'Một thuật toán đơn giản', 0),
(20, 'B20', N'Một mô hình học máy lấy cảm hứng từ não người', 1),
(20, 'C20', N'Một cơ sở dữ liệu', 0),
(20, 'D20', N'Một công cụ lập trình', 0);

-- Link Questions to Tests (5 questions per test)
INSERT INTO QuestionTest (QuestionID, TestOrder, CourseID, ChapterName) VALUES
-- Questions for React Course (Course 1)
-- Chương 1: Giới thiệu về ReactJS
(1, 1, 1, N'Chương 1: Giới thiệu về ReactJS'),    -- Test 1 của Chương 1 React Question 1
(2, 1, 1, N'Chương 1: Giới thiệu về ReactJS'),    -- Test 1 của Chương 1 React Question 2
(3, 1, 1, N'Chương 1: Giới thiệu về ReactJS'),    -- Test 1 của Chương 1 React Question 3
(4, 1, 1, N'Chương 1: Giới thiệu về ReactJS'),    -- Test 1 của Chương 1 React Question 4
(5, 1, 1, N'Chương 1: Giới thiệu về ReactJS'),    -- Test 1 của Chương 1 React Question 5

-- Test 2 của Chương 1 React
(6, 2, 1, N'Chương 1: Giới thiệu về ReactJS'),    -- Test 2 của Chương 1 React Question 6
(7, 2, 1, N'Chương 1: Giới thiệu về ReactJS'),    -- Test 2 của Chương 1 React Question 7
(8, 2, 1, N'Chương 1: Giới thiệu về ReactJS'),    -- Test 2 của Chương 1 React Question 8
(9, 2, 1, N'Chương 1: Giới thiệu về ReactJS'),    -- Test 2 của Chương 1 React Question 9
(10, 2, 1, N'Chương 1: Giới thiệu về ReactJS'),   -- Test 2 của Chương 1 React Question 10

-- Chương 2: JSX và Components
(11, 1, 1, N'Chương 2: JSX và Components'),        -- Test 1 của Chương 2 React Question 11
(12, 1, 1, N'Chương 2: JSX và Components'),        -- Test 1 của Chương 2 React Question 12
(13, 1, 1, N'Chương 2: JSX và Components'),        -- Test 1 của Chương 2 React Question 13
(14, 1, 1, N'Chương 2: JSX và Components'),        -- Test 1 của Chương 2 React Question 14
(15, 1, 1, N'Chương 2: JSX và Components'),        -- Test 1 của Chương 2 React Question 15

-- Test 2 của Chương 2 React
(16, 2, 1, N'Chương 2: JSX và Components'),        -- Test 2 của Chương 2 React Question 16
(17, 2, 1, N'Chương 2: JSX và Components'),        -- Test 2 của Chương 2 React Question 17
(18, 2, 1, N'Chương 2: JSX và Components'),        -- Test 2 của Chương 2 React Question 18
(19, 2, 1, N'Chương 2: JSX và Components'),        -- Test 2 của Chương 2 React Question 19
(20, 2, 1, N'Chương 2: JSX và Components'),        -- Test 2 của Chương 2 React Question 20

-- Chương 3: State và Props
(1, 1, 1, N'Chương 3: State và Props'),          -- Test 1 của Chương 3 React
(2, 1, 1, N'Chương 3: State và Props'),
(3, 1, 1, N'Chương 3: State và Props'),
(4, 1, 1, N'Chương 3: State và Props'),
(5, 1, 1, N'Chương 3: State và Props'),

(6, 2, 1, N'Chương 3: State và Props'),          -- Test 2 của Chương 3 React
(7, 2, 1, N'Chương 3: State và Props'),
(8, 2, 1, N'Chương 3: State và Props'),
(9, 2, 1, N'Chương 3: State và Props'),
(10, 2, 1, N'Chương 3: State và Props'),

-- Chương 4: React Hooks
(11, 1, 1, N'Chương 4: React Hooks'),            -- Test 1 của Chương 4 React
(12, 1, 1, N'Chương 4: React Hooks'),
(13, 1, 1, N'Chương 4: React Hooks'),
(14, 1, 1, N'Chương 4: React Hooks'),
(15, 1, 1, N'Chương 4: React Hooks'),

(16, 2, 1, N'Chương 4: React Hooks'),            -- Test 2 của Chương 4 React
(17, 2, 1, N'Chương 4: React Hooks'),
(18, 2, 1, N'Chương 4: React Hooks'),
(19, 2, 1, N'Chương 4: React Hooks'),
(20, 2, 1, N'Chương 4: React Hooks'),

-- COURSE 2: ANDROID
-- Chương 1: Cơ bản về Android
(1, 1, 2, N'Chương 1: Cơ bản về Android'),       -- Test 1 của Chương 1 Android
(2, 1, 2, N'Chương 1: Cơ bản về Android'),
(3, 1, 2, N'Chương 1: Cơ bản về Android'),
(4, 1, 2, N'Chương 1: Cơ bản về Android'),
(5, 1, 2, N'Chương 1: Cơ bản về Android'),

(6, 2, 2, N'Chương 1: Cơ bản về Android'),       -- Test 2 của Chương 1 Android
(7, 2, 2, N'Chương 1: Cơ bản về Android'),
(8, 2, 2, N'Chương 1: Cơ bản về Android'),
(9, 2, 2, N'Chương 1: Cơ bản về Android'),
(10, 2, 2, N'Chương 1: Cơ bản về Android'),

-- Chương 2: Layout và UI
(11, 1, 2, N'Chương 2: Layout và UI'),           -- Test 1 của Chương 2 Android
(12, 1, 2, N'Chương 2: Layout và UI'),
(13, 1, 2, N'Chương 2: Layout và UI'),
(14, 1, 2, N'Chương 2: Layout và UI'),
(15, 1, 2, N'Chương 2: Layout và UI'),

(16, 2, 2, N'Chương 2: Layout và UI'),           -- Test 2 của Chương 2 Android
(17, 2, 2, N'Chương 2: Layout và UI'),
(18, 2, 2, N'Chương 2: Layout và UI'),
(19, 2, 2, N'Chương 2: Layout và UI'),
(20, 2, 2, N'Chương 2: Layout và UI'),

-- Chương 3: Activities và Intents
(1, 1, 2, N'Chương 3: Activities và Intents'),    -- Test 1 của Chương 3 Android
(2, 1, 2, N'Chương 3: Activities và Intents'),
(3, 1, 2, N'Chương 3: Activities và Intents'),
(4, 1, 2, N'Chương 3: Activities và Intents'),
(5, 1, 2, N'Chương 3: Activities và Intents'),

(6, 2, 2, N'Chương 3: Activities và Intents'),    -- Test 2 của Chương 3 Android
(7, 2, 2, N'Chương 3: Activities và Intents'),
(8, 2, 2, N'Chương 3: Activities và Intents'),
(9, 2, 2, N'Chương 3: Activities và Intents'),
(10, 2, 2, N'Chương 3: Activities và Intents'),

-- Chương 4: Data Storage
(11, 1, 2, N'Chương 4: Data Storage'),            -- Test 1 của Chương 4 Android
(12, 1, 2, N'Chương 4: Data Storage'),
(13, 1, 2, N'Chương 4: Data Storage'),
(14, 1, 2, N'Chương 4: Data Storage'),
(15, 1, 2, N'Chương 4: Data Storage'),

(16, 2, 2, N'Chương 4: Data Storage'),            -- Test 2 của Chương 4 Android
(17, 2, 2, N'Chương 4: Data Storage'),
(18, 2, 2, N'Chương 4: Data Storage'),
(19, 2, 2, N'Chương 4: Data Storage'),
(20, 2, 2, N'Chương 4: Data Storage'),

-- COURSE 3: SQL
-- Chương 1: Cơ sở về SQL
(1, 1, 3, N'Chương 1: Cơ sở về SQL'),             -- Test 1 của Chương 1 SQL
(2, 1, 3, N'Chương 1: Cơ sở về SQL'),
(3, 1, 3, N'Chương 1: Cơ sở về SQL'),
(4, 1, 3, N'Chương 1: Cơ sở về SQL'),
(5, 1, 3, N'Chương 1: Cơ sở về SQL'),

(6, 2, 3, N'Chương 1: Cơ sở về SQL'),             -- Test 2 của Chương 1 SQL
(7, 2, 3, N'Chương 1: Cơ sở về SQL'),
(8, 2, 3, N'Chương 1: Cơ sở về SQL'),
(9, 2, 3, N'Chương 1: Cơ sở về SQL'),
(10, 2, 3, N'Chương 1: Cơ sở về SQL'),

-- Chương 2: Truy vấn cơ bản
(11, 1, 3, N'Chương 2: Truy vấn cơ bản'),         -- Test 1 của Chương 2 SQL
(12, 1, 3, N'Chương 2: Truy vấn cơ bản'),
(13, 1, 3, N'Chương 2: Truy vấn cơ bản'),
(14, 1, 3, N'Chương 2: Truy vấn cơ bản'),
(15, 1, 3, N'Chương 2: Truy vấn cơ bản'),

(16, 2, 3, N'Chương 2: Truy vấn cơ bản'),         -- Test 2 của Chương 2 SQL
(17, 2, 3, N'Chương 2: Truy vấn cơ bản'),
(18, 2, 3, N'Chương 2: Truy vấn cơ bản'),
(19, 2, 3, N'Chương 2: Truy vấn cơ bản'),
(20, 2, 3, N'Chương 2: Truy vấn cơ bản'),

-- Chương 3: Joins và Subqueries
(1, 1, 3, N'Chương 3: Joins và Subqueries'),      -- Test 1 của Chương 3 SQL
(2, 1, 3, N'Chương 3: Joins và Subqueries'),
(3, 1, 3, N'Chương 3: Joins và Subqueries'),
(4, 1, 3, N'Chương 3: Joins và Subqueries'),
(5, 1, 3, N'Chương 3: Joins và Subqueries'),

(6, 2, 3, N'Chương 3: Joins và Subqueries'),      -- Test 2 của Chương 3 SQL
(7, 2, 3, N'Chương 3: Joins và Subqueries'),
(8, 2, 3, N'Chương 3: Joins và Subqueries'),
(9, 2, 3, N'Chương 3: Joins và Subqueries'),
(10, 2, 3, N'Chương 3: Joins và Subqueries'),

-- Chương 4: Stored Procedures
(11, 1, 3, N'Chương 4: Stored Procedures'),        -- Test 1 của Chương 4 SQL
(12, 1, 3, N'Chương 4: Stored Procedures'),
(13, 1, 3, N'Chương 4: Stored Procedures'),
(14, 1, 3, N'Chương 4: Stored Procedures'),
(15, 1, 3, N'Chương 4: Stored Procedures'),

(16, 2, 3, N'Chương 4: Stored Procedures'),        -- Test 2 của Chương 4 SQL
(17, 2, 3, N'Chương 4: Stored Procedures'),
(18, 2, 3, N'Chương 4: Stored Procedures'),
(19, 2, 3, N'Chương 4: Stored Procedures'),
(20, 2, 3, N'Chương 4: Stored Procedures'),

-- COURSE 4: MACHINE LEARNING
-- Chương 1: Giới thiệu Machine Learning
(1, 1, 4, N'Chương 1: Giới thiệu Machine Learning'), -- Test 1 của Chương 1 ML
(2, 1, 4, N'Chương 1: Giới thiệu Machine Learning'),
(3, 1, 4, N'Chương 1: Giới thiệu Machine Learning'),
(4, 1, 4, N'Chương 1: Giới thiệu Machine Learning'),
(5, 1, 4, N'Chương 1: Giới thiệu Machine Learning'),

(6, 2, 4, N'Chương 1: Giới thiệu Machine Learning'), -- Test 2 của Chương 1 ML
(7, 2, 4, N'Chương 1: Giới thiệu Machine Learning'),
(8, 2, 4, N'Chương 1: Giới thiệu Machine Learning'),
(9, 2, 4, N'Chương 1: Giới thiệu Machine Learning'),
(10, 2, 4, N'Chương 1: Giới thiệu Machine Learning'),

-- Chương 2: Supervised Learning
(11, 1, 4, N'Chương 2: Supervised Learning'),       -- Test 1 của Chương 2 ML
(12, 1, 4, N'Chương 2: Supervised Learning'),
(13, 1, 4, N'Chương 2: Supervised Learning'),
(14, 1, 4, N'Chương 2: Supervised Learning'),
(15, 1, 4, N'Chương 2: Supervised Learning'),

(16, 2, 4, N'Chương 2: Supervised Learning'),       -- Test 2 của Chương 2 ML
(17, 2, 4, N'Chương 2: Supervised Learning'),
(18, 2, 4, N'Chương 2: Supervised Learning'),
(19, 2, 4, N'Chương 2: Supervised Learning'),
(20, 2, 4, N'Chương 2: Supervised Learning'),

-- Chương 3: Unsupervised Learning
(1, 1, 4, N'Chương 3: Unsupervised Learning'),     -- Test 1 của Chương 3 ML
(2, 1, 4, N'Chương 3: Unsupervised Learning'),
(3, 1, 4, N'Chương 3: Unsupervised Learning'),
(4, 1, 4, N'Chương 3: Unsupervised Learning'),
(5, 1, 4, N'Chương 3: Unsupervised Learning'),

(6, 2, 4, N'Chương 3: Unsupervised Learning'),     -- Test 2 của Chương 3 ML
(7, 2, 4, N'Chương 3: Unsupervised Learning'),
(8, 2, 4, N'Chương 3: Unsupervised Learning'),
(9, 2, 4, N'Chương 3: Unsupervised Learning'),
(10, 2, 4, N'Chương 3: Unsupervised Learning'),

-- Chương 4: Deep Learning
(11, 1, 4, N'Chương 4: Deep Learning'),            -- Test 1 của Chương 4 ML
(12, 1, 4, N'Chương 4: Deep Learning'),
(13, 1, 4, N'Chương 4: Deep Learning'),
(14, 1, 4, N'Chương 4: Deep Learning'),
(15, 1, 4, N'Chương 4: Deep Learning'),

(16, 2, 4, N'Chương 4: Deep Learning'),            -- Test 2 của Chương 4 ML
(17, 2, 4, N'Chương 4: Deep Learning'),
(18, 2, 4, N'Chương 4: Deep Learning'),
(19, 2, 4, N'Chương 4: Deep Learning'),
(20, 2, 4, N'Chương 4: Deep Learning');

-- Student 7 - Course 1 (React)
INSERT INTO Student_Test (StudentID, CourseID, TestOrder, ChapterName, TestScore)
VALUES
(7, 1, 1, N'Chương 1: Giới thiệu về ReactJS', 0),
(7, 1, 2, N'Chương 1: Giới thiệu về ReactJS', 0),
(7, 1, 1, N'Chương 2: JSX và Components', 0),
(7, 1, 2, N'Chương 2: JSX và Components', 0),
(7, 1, 1, N'Chương 3: State và Props', 0),
(7, 1, 2, N'Chương 3: State và Props', 0),
(7, 1, 1, N'Chương 4: React Hooks', 0),
(7, 1, 2, N'Chương 4: React Hooks', 0);

-- Student 7 - Course 2 (Android)
INSERT INTO Student_Test (StudentID, CourseID, TestOrder, ChapterName, TestScore)
VALUES
(7, 2, 1, N'Chương 1: Cơ bản về Android', 8),
(7, 2, 2, N'Chương 1: Cơ bản về Android', 9),
(7, 2, 1, N'Chương 2: Layout và UI', 7),
(7, 2, 2, N'Chương 2: Layout và UI', 8),
(7, 2, 1, N'Chương 3: Activities và Intents', 8),
(7, 2, 2, N'Chương 3: Activities và Intents', 6),
(7, 2, 1, N'Chương 4: Data Storage', 9),
(7, 2, 2, N'Chương 4: Data Storage', 10);

-- Student 8 - Course 1 (React)
INSERT INTO Student_Test (StudentID, CourseID, TestOrder, ChapterName, TestScore)
VALUES
(8, 1, 1, N'Chương 1: Giới thiệu về ReactJS', 2),
(8, 1, 2, N'Chương 1: Giới thiệu về ReactJS', 7),
(8, 1, 1, N'Chương 2: JSX và Components', 8),
(8, 1, 2, N'Chương 2: JSX và Components', 5),
(8, 1, 1, N'Chương 3: State và Props', 6),
(8, 1, 2, N'Chương 3: State và Props', 8),
(8, 1, 1, N'Chương 4: React Hooks', 5),
(8, 1, 2, N'Chương 4: React Hooks', 6);

-- Student 8 - Course 3 (SQL)
INSERT INTO Student_Test (StudentID, CourseID, TestOrder, ChapterName, TestScore)
VALUES
(8, 3, 1, N'Chương 1: Cơ sở về SQL', 5),
(8, 3, 2, N'Chương 1: Cơ sở về SQL', 4),
(8, 3, 1, N'Chương 2: Truy vấn cơ bản', 5),
(8, 3, 2, N'Chương 2: Truy vấn cơ bản', 6),
(8, 3, 1, N'Chương 3: Joins và Subqueries', 5),
(8, 3, 2, N'Chương 3: Joins và Subqueries', 5),
(8, 3, 1, N'Chương 4: Stored Procedures', 6),
(8, 3, 2, N'Chương 4: Stored Procedures', 7);

-- Student 9 - Course 2 (Android)
INSERT INTO Student_Test (StudentID, CourseID, TestOrder, ChapterName, TestScore)
VALUES
(9, 2, 1, N'Chương 1: Cơ bản về Android', 8),
(9, 2, 2, N'Chương 1: Cơ bản về Android', 8),
(9, 2, 1, N'Chương 2: Layout và UI', 9),
(9, 2, 2, N'Chương 2: Layout và UI', 7),
(9, 2, 1, N'Chương 3: Activities và Intents', 9),
(9, 2, 2, N'Chương 3: Activities và Intents', 8),
(9, 2, 1, N'Chương 4: Data Storage', 9),
(9, 2, 2, N'Chương 4: Data Storage', 9);

-- Student 9 - Course 4 (ML)
INSERT INTO Student_Test (StudentID, CourseID, TestOrder, ChapterName, TestScore)
VALUES
(9, 4, 1, N'Chương 1: Giới thiệu Machine Learning', 9),
(9, 4, 2, N'Chương 1: Giới thiệu Machine Learning', 7),
(9, 4, 1, N'Chương 2: Supervised Learning', 8),
(9, 4, 2, N'Chương 2: Supervised Learning', 7),
(9, 4, 1, N'Chương 3: Unsupervised Learning', 8),
(9, 4, 2, N'Chương 3: Unsupervised Learning', 9),
(9, 4, 1, N'Chương 4: Deep Learning', 9),
(9, 4, 2, N'Chương 4: Deep Learning', 9);

-- Student 10 - Course 3 (SQL)
INSERT INTO Student_Test (StudentID, CourseID, TestOrder, ChapterName, TestScore)
VALUES
(10, 3, 1, N'Chương 1: Cơ sở về SQL', 6),
(10, 3, 2, N'Chương 1: Cơ sở về SQL', 5),
(10, 3, 1, N'Chương 2: Truy vấn cơ bản', 6),
(10, 3, 2, N'Chương 2: Truy vấn cơ bản', 7),
(10, 3, 1, N'Chương 3: Joins và Subqueries', 6),
(10, 3, 2, N'Chương 3: Joins và Subqueries', 5),
(10, 3, 1, N'Chương 4: Stored Procedures', 6),
(10, 3, 2, N'Chương 4: Stored Procedures', 6);

-- Student 11 - Course 4 (ML)
INSERT INTO Student_Test (StudentID, CourseID, TestOrder, ChapterName, TestScore)
VALUES
(11, 4, 1, N'Chương 1: Giới thiệu Machine Learning', 5),
(11, 4, 2, N'Chương 1: Giới thiệu Machine Learning', 5),
(11, 4, 1, N'Chương 2: Supervised Learning', 5),
(11, 4, 2, N'Chương 2: Supervised Learning', 5),
(11, 4, 1, N'Chương 3: Unsupervised Learning', 8),
(11, 4, 2, N'Chương 3: Unsupervised Learning', 8),
(11, 4, 1, N'Chương 4: Deep Learning', 9),
(11, 4, 2, N'Chương 4: Deep Learning', 8);






INSERT INTO Lesson (LessonOrder, CourseID, ChapterName, LessonTitle, LessonContent, LessonDuraion) VALUES
-- Lessons của Chapter 1 React
(1, 1, N'Chương 1: Giới thiệu về ReactJS', N'Bài 1: Tổng quan về ReactJS', N'Giới thiệu về ReactJS và ứng dụng', '01:30:00'),
(2, 1, N'Chương 1: Giới thiệu về ReactJS', N'Bài 2: Cài đặt môi trường', N'Hướng dẫn cài đặt NodeJS và create-react-app', '01:00:00'),

-- Lessons của Chapter 2 React
(1, 1, N'Chương 2: JSX và Components', N'Bài 1: JSX là gì', N'Tìm hiểu về JSX và cách sử dụng', '02:00:00'),
(2, 1, N'Chương 2: JSX và Components', N'Bài 2: Components', N'Các loại components trong React', '01:45:00');

-- Thêm Exercise cho các Lesson của React
INSERT INTO Exercise (ExerciseOrder, LessonOrder, CourseID, ChapterName, ExerciseTitle, ExerciseContent, ExerciseAnswer, ExerciseCorrectAnswerNumber) VALUES
-- Exercise cho Lesson 1 Chapter 1 React
(1, 1, 1, N'Chương 1: Giới thiệu về ReactJS', N'React là gì?', N'Chọn định nghĩa đúng về React: A. Framework, B. Library, C. Programming Language', 'B', 2),
(2, 1, 1, N'Chương 1: Giới thiệu về ReactJS', N'Ai phát triển React?', N'Ai phát triển React: A. Google, B. Facebook, C. Microsoft', 'B', 2),

-- Exercise cho Lesson 2 Chapter 1 React
(1, 2, 1, N'Chương 1: Giới thiệu về ReactJS', N'NodeJS version', N'Version tối thiểu của NodeJS để chạy React là: A. 10.x, B. 12.x, C. 14.x', 'C', 3);

-- Thêm Document cho các Course
INSERT INTO Document (CourseID, ChapterName, DocumentAuthor, DocumentTitle, DocumentSize, DocumentType, DocumentContent) VALUES
-- Documents cho React Course
(1, N'Chương 1: Giới thiệu về ReactJS', N'React Team', N'React Fundamentals.pdf', 1024, 'pdf', N'Link to React Fundamentals PDF'),
(1, N'Chương 2: JSX và Components', N'React Team', N'JSX Guide.pdf', 2048, 'pdf', N'Link to JSX Guide PDF'),
(1, N'Chương 3: State và Props', N'React Team', N'State Management.pdf', 1536, 'pdf', N'Link to State Management PDF'),

-- Documents cho Android Course
(2, N'Chương 1: Cơ bản về Android', N'Android Team', N'Android Basics.pdf', 2048, 'pdf', N'Link to Android Basics PDF'),
(2, N'Chương 2: Layout và UI', N'Android Team', N'UI Design Guide.pdf', 1536, 'pdf', N'Link to UI Design PDF'),

-- Documents cho SQL Course
(3, N'Chương 1: Cơ sở về SQL', N'SQL Team', N'SQL Fundamentals.pdf', 1024, 'pdf', N'Link to SQL Fundamentals PDF'),
(3, N'Chương 2: Truy vấn cơ bản', N'SQL Team', N'Basic Queries.pdf', 1536, 'pdf', N'Link to Basic Queries PDF'),

-- Documents cho ML Course
(4, N'Chương 1: Giới thiệu Machine Learning', N'ML Team', N'ML Introduction.pdf', 2048, 'pdf', N'Link to ML Introduction PDF'),
(4, N'Chương 2: Supervised Learning', N'ML Team', N'Supervised Learning Guide.pdf', 1536, 'pdf', N'Link to Supervised Learning PDF');

INSERT INTO Guardian (StudentID, GuardianName, GuardianEmail, GuardianPhone) VALUES
-- Guardian cho student 7 (Trần Văn G)
(7, N'Trần Văn Minh', 'tvanminh@gmail.com', '0912345678'),
-- Guardian cho student 8 (Nguyễn Thị H)
(8, N'Nguyễn Văn Nam', 'nvnam@gmail.com', '0923456789'),
-- Guardian cho student 9 (Lê Văn I)
(9, N'Lê Thị Hương', 'lthuong@gmail.com', '0934567890'),
-- Guardian cho student 10 (Phạm Thị K)
(10, N'Phạm Văn Đức', 'pvduc@gmail.com', '0945678901'),
-- Guardian cho student 11 (Hoàng Văn L)
(11, N'Hoàng Thị Mai', 'htmai@gmail.com', '0956789012'),
-- Guardian cho student 12 (Ngô Thị M)
(12, N'Ngô Văn Hùng', 'nvhung@gmail.com', '0967890123'),
-- Guardian cho student 13 (Vũ Văn N)
(13, N'Vũ Thị Lan', 'vtlan@gmail.com', '0978901234'),
-- Guardian cho student 14 (Đặng Thị O)
(14, N'Đặng Văn Thành', 'dvthanh@gmail.com', '0989012345'),
-- Guardian cho student 15 (Bùi Văn P)
(15, N'Bùi Thị Hà', 'btha@gmail.com', '0990123456'),
-- Guardian cho student 16 (Mai Thị Q)
(16, N'Mai Văn Long', 'mvlong@gmail.com', '0901234567'),
-- Guardian cho student 17 (Lý Văn R)
(17, N'Lý Thị Ngọc', 'ltngoc@gmail.com', '0912345670'),
-- Guardian cho student 18 (Trịnh Thị S)
(18, N'Trịnh Văn Tùng', 'tvtung@gmail.com', '0923456781'),
-- Guardian cho student 19 (Đinh Văn T)
(19, N'Đinh Thị Thảo', 'dtthao@gmail.com', '0934567892'),
-- Guardian cho student 20 (Cao Thị U)
(20, N'Cao Văn Phong', 'cvphong@gmail.com', '0945678903');

INSERT INTO Edit (EditTime, EditDescription, EditAdminID, EditCouponID, EditCourseID) VALUES
-- Chỉnh sửa khóa học
('13:00:00', N'Cập nhật mô tả khóa học React', 1, NULL, 1),
('14:30:00', N'Thay đổi giá khóa học Android', 1, NULL, 2),
('15:45:00', N'Cập nhật nội dung khóa học SQL', 2, NULL, 3),
('16:20:00', N'Điều chỉnh thời gian học ML', 2, NULL, 4),
-- Chỉnh sửa coupon
('09:00:00', N'Tạo mới coupon giảm 15%', 1, 1, NULL),
('09:30:00', N'Điều chỉnh hạn sử dụng coupon 25%', 1, 2, NULL);







---------------------------------------------------------------------2.1---------------------------------------------------------------------
-- INSERT COUPON
GO
CREATE PROCEDURE InsertCoupon
    @CouponTitle NVARCHAR(255),
    @CouponValue INT,
    @CouponType NVARCHAR(255),
    @CouponStartDate DATE,
    @CouponExpire DATE,
    @CouponMaxDiscount INT,
    @ErrorMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validate nulls
        IF @CouponTitle IS NULL OR @CouponValue IS NULL OR @CouponType IS NULL OR
           @CouponStartDate IS NULL OR @CouponExpire IS NULL OR @CouponMaxDiscount IS NULL
        BEGIN
            PRINT 'Lỗi: Dữ liệu không được để trống.'
            RAISERROR('Dữ liệu không được để trống.', 16, 1)
            RETURN
        END

        -- Validate title
        IF LEN(TRIM(@CouponTitle)) = 0
        BEGIN
            PRINT 'Lỗi: Tiêu đề mã giảm giá không được để trống.'
            RAISERROR('Tiêu đề mã giảm giá không được để trống.', 16, 1)
            RETURN
        END

        -- Validate type
        IF @CouponType NOT IN ('percent', 'fixed')
        BEGIN
            PRINT 'Lỗi: Loại mã giảm giá không hợp lệ.'
            RAISERROR('Loại mã giảm giá không hợp lệ.', 16, 1)
            RETURN
        END

        -- Validate value
        IF @CouponValue <= 0
        BEGIN
            PRINT 'Lỗi: Giá trị mã giảm giá phải lớn hơn 0.'
            RAISERROR('Giá trị mã giảm giá phải lớn hơn 0.', 16, 1)
            RETURN
        END

        -- Validate dates
        IF @CouponStartDate < GETDATE()
        BEGIN
            PRINT 'Lỗi: Ngày bắt đầu không được trong quá khứ.'
            RAISERROR('Ngày bắt đầu không được trong quá khứ.', 16, 1)
            RETURN
        END

        IF @CouponStartDate >= @CouponExpire
        BEGIN
            PRINT 'Lỗi: Ngày bắt đầu mã giảm giá phải trước ngày hết hạn.'
            RAISERROR('Ngày bắt đầu mã giảm giá phải trước ngày hết hạn.', 16, 1)
            RETURN
        END

        -- Validate max discount
        IF @CouponMaxDiscount < 0
        BEGIN
            PRINT 'Lỗi: Giá trị giảm giá tối đa phải lớn hơn hoặc bằng 0.'
            RAISERROR('Giá trị giảm giá tối đa phải lớn hơn hoặc bằng 0.', 16, 1)
            RETURN
        END

        -- Validate percentage type
        IF @CouponType = 'percent' AND (@CouponValue > 100 OR @CouponValue < 0)
        BEGIN
            PRINT 'Lỗi: Giá trị phần trăm phải nằm trong khoảng từ 0 đến 100.'
            RAISERROR('Giá trị phần trăm phải nằm trong khoảng từ 0 đến 100.', 16, 1)
            RETURN
        END

        -- Validate value type
        IF @CouponType = 'fixed' AND @CouponValue <= 0
        BEGIN
            PRINT 'Lỗi: Giá trị giảm giá phải lớn hơn 0.'
            RAISERROR('Giá trị giảm giá phải lớn hơn 0.', 16, 1)
            RETURN
        END

        -- Check duplicate title
        IF EXISTS (SELECT 1 FROM Coupon WHERE CouponTitle = @CouponTitle)
        BEGIN
            PRINT 'Lỗi: Tiêu đề mã giảm giá đã tồn tại.'
            RAISERROR('Tiêu đề mã giảm giá đã tồn tại.', 16, 1)
            RETURN
        END

        --nếu type = giá trị thì max discount phải <= value
        IF @CouponType = 'fixed' AND @CouponMaxDiscount > @CouponValue
        BEGIN
            PRINT 'Lỗi: Giá trị giảm giá tối đa phải nhỏ hơn hoặc bằng giá trị giảm giá.'
            RAISERROR('Giá trị giảm giá tối đa phải nhỏ hơn hoặc bằng giá trị giảm giá.', 16, 1)
            RETURN
        END

        -- Insert with transaction
        BEGIN TRANSACTION
            INSERT INTO Coupon (
                CouponTitle,
                CouponValue,
                CouponType,
                CouponStartDate,
                CouponExpire,
                CouponMaxDiscount
            )
            VALUES (
                @CouponTitle,
                @CouponValue,
                @CouponType,
                @CouponStartDate,
                @CouponExpire,
                @CouponMaxDiscount
            )
        COMMIT TRANSACTION

        PRINT 'Thêm mã giảm giá thành công.'
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION



        -- PRINT 'Lỗi: ' + ERROR_MESSAGE()
        SET @ErrorMessage = ERROR_MESSAGE()
        PRINT @ErrorMessage
        RETURN
    END CATCH
END
GO

--UPDATE COUPON
CREATE PROCEDURE UpdateCoupon
    @CouponID VARCHAR(20),
    @CouponTitle NVARCHAR(255),
    @CouponValue INT,
    @CouponType VARCHAR(255),
    @CouponStartDate DATE,
    @CouponExpire DATE,
    @CouponMaxDiscount DECIMAL(10,2),
    @ErrorMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    BEGIN TRY


        -- Validate input

        IF @CouponStartDate < GETDATE()
        BEGIN
            RAISERROR('Ngày bắt đầu không được trong quá khứ', 16, 1)
            RETURN
        END

        IF @CouponStartDate > @CouponExpire
        BEGIN
            RAISERROR('Ngày bắt đầu không được lớn hơn ngày kết thúc', 16, 1)
            RETURN
        END



        IF @CouponMaxDiscount <= 0
        BEGIN
            RAISERROR('Giá trị giảm giá phải lớn hơn 0', 16, 1)
            RETURN
        END


        --Validate coupon type
        IF @CouponType NOT IN ('percent', 'fixed')
        BEGIN
            RAISERROR('Loại mã giảm giá không hợp lệ', 16, 1)
            RETURN
        END

        --Validate coupon percentage range
        IF @CouponType = 'percent' AND (@CouponValue <= 0 OR @CouponValue > 100)
        BEGIN
            RAISERROR('Giá trị phần trăm phải nằm trong khoảng từ 0 đến 100', 16, 1)
            RETURN
        END

        --Validate coupon value
        IF @CouponType = 'fixed' AND @CouponValue <= 0
        BEGIN
            RAISERROR('Giá trị giảm giá phải lớn hơn 0', 16, 1)
            RETURN
        END

        --check if coupon exists
        IF NOT EXISTS (SELECT 1 FROM Coupon WHERE CouponID = @CouponID)
        BEGIN
            RAISERROR(N'Không tìm thấy mã giảm giá', 16, 1)
            RETURN
        END




        BEGIN TRANSACTION
            UPDATE Coupon
            SET
                CouponTitle = @CouponTitle,
                CouponValue = @CouponValue,
                CouponType = @CouponType,
                CouponStartDate = @CouponStartDate,
                CouponExpire = @CouponExpire,
                CouponMaxDiscount = @CouponMaxDiscount
            WHERE CouponID = @CouponID

            IF @@ROWCOUNT = 0
            BEGIN
                RAISERROR('Không tìm thấy mã giảm giá', 16, 1)
                ROLLBACK TRANSACTION
                RETURN
            END

        COMMIT TRANSACTION
        PRINT 'Cập nhật mã giảm giá thành công.'
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION

        PRINT 'Lỗi: ' + ERROR_MESSAGE()
        SET @ErrorMessage = ERROR_MESSAGE()
        RETURN
    END CATCH
END
GO



--DELETE COUPON
CREATE PROCEDURE DeleteCoupon
    @CouponID VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            -- Check if coupon exists
            IF NOT EXISTS (SELECT 1 FROM Coupon WHERE CouponID = @CouponID)
            BEGIN
                RAISERROR('Không tìm thấy mã giảm giá', 16, 1)
                RETURN
            END


            --DELETE Edit
            DELETE FROM Edit
            WHERE EditCouponID = @CouponID


            -- Delete the coupon
            DELETE FROM Coupon
            WHERE CouponID = @CouponID

            IF @@ROWCOUNT > 0
                PRINT 'Xóa mã giảm giá thành công.'
            ELSE
                RAISERROR('Không thể xóa mã giảm giá', 16, 1)

        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION

        PRINT 'Lỗi: ' + ERROR_MESSAGE()
    END CATCH
END
GO





---------------------------------------------------------------------2.4---------------------------------------------------------------------
-- Hàm tính tổng doanh thu từ các đơn hàng của một khóa học

GO
CREATE FUNCTION CalculateTotalRevenue
(
    @CourseID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @TotalRevenue INT = 0;
    DECLARE @OrderID INT;
    DECLARE @CoursePrice INT;

    -- Kiểm tra xem CourseID có tồn tại trong bảng
    IF NOT EXISTS (SELECT 1 FROM Course WHERE CourseID = @CourseID)
    BEGIN
        RETURN -1; -- Trả về -1 nếu CourseID không hợp lệ
    END

    -- Khai báo con trỏ để lặp qua các đơn hàng liên quan đến khóa học
    DECLARE OrderCursor CURSOR FOR
    SELECT OrderID FROM CourseOrder WHERE CourseID = @CourseID;

    -- Mở con trỏ để lấy OrderID đầu tiên
    OPEN OrderCursor;
    FETCH NEXT FROM OrderCursor INTO @OrderID; -- Lấy OrderID đầu tiên

    -- Lặp qua các đơn hàng để tính tổng doanh thu
    WHILE @@FETCH_STATUS = 0 -- Nếu còn dữ liệu
    BEGIN
        -- Lấy giá khoá học từ bảng Course
        SELECT @CoursePrice = CoursePrice FROM Course WHERE CourseID = @CourseID;
        -- Cộng vào tổng doanh thu
        SET @TotalRevenue = @TotalRevenue + @CoursePrice;

        -- Lấy OrderID tiếp theo
        FETCH NEXT FROM OrderCursor INTO @OrderID;
    END

    -- Đóng con trỏ và thu hồi bộ nhớ
    CLOSE OrderCursor;
    DEALLOCATE OrderCursor;

    -- Trả về tổng doanh thu
    RETURN @TotalRevenue;
END;
GO

DECLARE @Revenue INT;
SET @Revenue = dbo.CalculateTotalRevenue(1); -- Tính tổng doanh thu từ khóa học có CourseID = 1
PRINT 'Total Revenue: ' + CAST(@Revenue AS NVARCHAR);




------
-- Hàm tính điểm trung bình của một học sinh
GO
CREATE FUNCTION CalculateAverageTestScore
(
    @StudentID INT
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @TotalScore FLOAT = 0;
    DECLARE @TestCount INT = 0;
    DECLARE @AverageScore FLOAT = 0;
    DECLARE @TestScore FLOAT;
    DECLARE @CourseID INT;
    DECLARE @TestOrder INT;
    DECLARE @ChapterName NVARCHAR(255);

    -- Kiểm tra xem StudentID có tồn tại trong bảng
    IF NOT EXISTS (SELECT 1 FROM Student WHERE StudentID = @StudentID)
    BEGIN
        RETURN -1; -- Trả về -1 nếu StudentID không hợp lệ
    END

    -- Khai báo con trỏ để lặp qua các bài kiểm tra của học sinh
    DECLARE TestCursor CURSOR FOR
    SELECT CourseID, TestOrder, ChapterName, TestScore
    FROM Student_Test
    WHERE StudentID = @StudentID;

    -- Mở con trỏ để lấy bài kiểm tra đầu tiên
    OPEN TestCursor;
    FETCH NEXT FROM TestCursor INTO @CourseID, @TestOrder, @ChapterName, @TestScore;

    -- Lặp qua các bài kiểm tra để tính điểm trung bình
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Cộng vào tổng điểm
        SET @TotalScore = @TotalScore + @TestScore;
        -- Đếm số lượng bài kiểm tra
        SET @TestCount = @TestCount + 1;

        -- Lấy bài kiểm tra tiếp theo
        FETCH NEXT FROM TestCursor INTO @CourseID, @TestOrder, @ChapterName, @TestScore;
    END

    -- Đóng con trỏ và thu hồi bộ nhớ
    CLOSE TestCursor;
    DEALLOCATE TestCursor;

    -- Tính điểm trung bình
    IF @TestCount > 0
    BEGIN
        SET @AverageScore = @TotalScore / @TestCount;
    END
    ELSE
    BEGIN
        RETURN 0; -- Trả về 0 nếu không có bài kiểm tra nào
    END

    -- Return the average score
    RETURN @AverageScore;
END;
GO

DECLARE @AvgScore FLOAT;
SET @AvgScore = dbo.CalculateAverageTestScore(8); -- Tính điểm trung bình của học sinh có StudentID = 8
PRINT 'Average Test Score: ' + CAST(@AvgScore AS NVARCHAR);















