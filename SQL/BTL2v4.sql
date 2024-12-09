
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

-- Thủ tục thêm mới phiếu giảm giá
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






--test
SELECT * FROM Coupon
EXEC InsertCoupon 'Mã giảm giá 1', 10, 'percent', '2028-01-01', '2029-12-31', 100, ''
EXEC InsertCoupon 'Mã giảm giá 2', 100000, 'fixed', '2029-01-01', '2029-12-31', 100000, ''
EXEC InsertCoupon 'Mã giảm giá 3', 100000, 'percent', '2029-01-01', '2029-12-31', 100000, ''

EXEC UpdateCoupon '1', 'Mã giảm giá 1', 20, 'percent', '2029-01-01', '2029-12-31', 100, ''
EXEC UpdateCoupon '2', 'Mã giảm giá 2', 200000, 'fixed', '2029-01-01', '2029-12-31', 100000, ''

EXEC DeleteCoupon '1'
EXEC DeleteCoupon '2'