
--cd "D:\HCSDL\BTL\BTL2 HCSDL"
--git add .
--git commit -m ""
--git push origin master
-------------------------------- TẠO CSDL --------------------------------

-- CREATE DATABASE OnlineCoursePlatform;
-- GO

-- USE OnlineCoursePlatform;
-- GO

-- Tạo bảng Users
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY,
    UserName NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE,
    PhoneNumber NVARCHAR(20),
    Password NVARCHAR(100),
    Address NVARCHAR(255),
    Avatar NVARCHAR(255)
);

-- Tạo bảng Students
CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY,
    UserID INT UNIQUE,
    -- Các thuộc tính riêng của Students
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Tạo bảng Instructors
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY IDENTITY,
    UserID INT UNIQUE,
    -- Các thuộc tính riêng của Instructors
    InstructorDescription NVARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Tạo bảng Admins
CREATE TABLE Admins (
    AdminID INT PRIMARY KEY IDENTITY,
    UserID INT UNIQUE,
    -- Các thuộc tính riêng của Admins
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Bảng người đại diện
CREATE TABLE Guardians (
    GuardianID INT PRIMARY KEY IDENTITY,
    GuardianName NVARCHAR(100),
    GuardianContactInfo NVARCHAR(255),
    StudentID INT UNIQUE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

-- Tạo bảng danh mục
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY,
    CategoryName NVARCHAR(100),
    CategoryDescription NVARCHAR(255)
);

-- Tạo bảng khoá học
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100),
    Description NVARCHAR(255),
    Price DECIMAL(10, 2),
    Avatar NVARCHAR(255),
    Status NVARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    InstructorID INT,
    CategoryID INT,
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Nội dung của khoá học
CREATE TABLE CourseContents (
    ContentID INT PRIMARY KEY IDENTITY,
    CourseID INT,
    ContentDescription NVARCHAR(255),

    CONSTRAINT FK_CourseContents_Courses FOREIGN KEY (CourseID)
        REFERENCES Courses(CourseID)
        ON DELETE CASCADE
);

-- Bảng đánh giá
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY IDENTITY,
    CourseID INT,
    StudentID INT,
    Rating INT,
    Comment NVARCHAR(255),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

-- Bảng giỏ hàng
CREATE TABLE Carts (
    CartID INT PRIMARY KEY IDENTITY,
    StudentID INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

-- Bảng chi tiết giỏ hàng, mỗi bảng là một mặt hàng (khoá học) trong giỏ hàng
-- Quan hệ 1-n với bảng giỏ hàng
CREATE TABLE CartItems (
    CartItemID INT PRIMARY KEY IDENTITY,
    CartID INT,
    CourseID INT,
    FOREIGN KEY (CartID) REFERENCES Carts(CartID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE
);

-- Bảng đơn hàng
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY,
    StudentID INT,
    Status NVARCHAR(50),
    -- PaymentMethod NVARCHAR(50),
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE
);

-- Bảng chi tiết đơn hàng, mỗi bảng là một mặt hàng (khoá học) trong đơn hàng
-- Quan hệ 1-n với bảng đơn hàng
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY,
    OrderID INT,
    CourseID INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE
);

-- Bảng thanh toán
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY,
    OrderID INT,
    Amount DECIMAL(10, 2),
    PaymentCode NVARCHAR(100),
    PaymentDate DATE,
    PaymentMethod NVARCHAR(50),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);

--Momo
CREATE TABLE MomoPayments (
    PaymentID INT PRIMARY KEY,
    PhoneNumber NVARCHAR(15),
    FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID)
);

--Visa
CREATE TABLE VisaPayments (
    PaymentID INT PRIMARY KEY,
    CardNumber NVARCHAR(20),
    ExpirationDate DATE,
    FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID)
);

--Internet Banking
CREATE TABLE InternetBankingPayments (
    PaymentID INT PRIMARY KEY,
    BankName NVARCHAR(100),
    FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID)
);

-- Mã giảm giá
CREATE TABLE Coupons (
    CouponID INT PRIMARY KEY IDENTITY,
    Title NVARCHAR(100),
    Value DECIMAL(10, 2),
    DiscountType NVARCHAR(50),
    ExpiryDate DATE,
    Conditions NVARCHAR(255)
);

-- Admin sửa thông tin khoá học/phiếu giảm giá
CREATE TABLE Edits (
    EditID INT PRIMARY KEY IDENTITY,
    AdminID INT,
    EditTime DATETIME,
    CourseID INT NULL,
    CouponID INT NULL,
    FOREIGN KEY (AdminID) REFERENCES Admins(AdminID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) ON DELETE CASCADE,
    FOREIGN KEY (CouponID) REFERENCES Coupons(CouponID)
);

-- Đảm bảo chỉ có một trong hai trường CourseID hoặc CouponID được điền khi sửa thông tin
ALTER TABLE Edits
ADD CONSTRAINT CK_Edits_OnlyOneNotNull CHECK (
    (CourseID IS NOT NULL AND CouponID IS NULL) OR
    (CourseID IS NULL AND CouponID IS NOT NULL)
);






-------------------------------- CHÈN DỮ LIỆU MẪU --------------------------------

-- Bảng Users
SET IDENTITY_INSERT Users ON;

INSERT INTO Users (UserID, UserName, Email, PhoneNumber, Password, Address, Avatar)
VALUES
(1, 'Nguyen Van A', 'A@example.com', '224-3123', 'password123', '456 Main St', 'avatar.jpg'),
(2, 'Nguyen Thi C', 'C@example.com', '523-5523', 'password123', '314 Main St', 'avatar.jpg'),
(3, 'Tran Minh X', 'Xstu@gmail.com', '412-5124', 'password123', '512 Main St', 'avatar.jpg'),
(4, 'Tran Thi Y', 'Ystu@gmail.com', '123-1234', 'password123', '123 Main St', 'avatar.jpg'),
(5, 'Le Van Z', 'Z@gmail.com', '789-7890', 'password123', '789 Main St', 'avatar.jpg'),
(6, 'Phạm Văn X', 'X@gmail.com', '0123456783', '123456', '789 Main St', 'avatar3.jpg'),
(7, 'Lê Thị Y', 'YYY@gmail.com', '0123456784', '123456', '789 Main St', 'avatar4.jpg'),
(8, 'Nguyễn Văn Z', 'ZZZ@gmail.com', '0123456785', '123456', '789 Main St', 'avatar5.jpg'),
(9, 'Trần Thị T', 'TT@gmail.com', '0123456786', '123456', '789 Main St', 'avatar6.jpg'),
(10, 'Lê Văn S', 'S@gmail.com', '0123456787', '123456', '789 Main St', 'avatar7.jpg');

SET IDENTITY_INSERT Users OFF;

-- Bảng Students
SET IDENTITY_INSERT Students ON;

INSERT INTO Students (StudentID, UserID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

SET IDENTITY_INSERT Students OFF;

-- Bảng Instructors
SET IDENTITY_INSERT Instructors ON;

INSERT INTO Instructors (InstructorID, UserID, InstructorDescription)
VALUES
(1, 6, 'Giảng viên khoa học máy tính'),
(2, 7, 'Giảng viên toán học'),
(3, 8, 'Giảng viên vật lý'),
(4, 9, 'Giảng viên hóa học'),
(5, 10, 'Giảng viên sinh học');

SET IDENTITY_INSERT Instructors OFF;


-- Bảng Admins
SET IDENTITY_INSERT Admins ON;

INSERT INTO Admins (AdminID, UserID)
VALUES
(1, 1),
(2, 2);

SET IDENTITY_INSERT Admins OFF;

-- Bảng Categories
SET IDENTITY_INSERT Categories ON;

INSERT INTO Categories (CategoryID, CategoryName, CategoryDescription)
VALUES
(1, 'Programming', 'Khoá học lập trình'),
(2, 'Math', 'Khoá học giải tích'),
(3, 'Physics', 'Khoá học vật lý'),
(4, 'Chemistry', 'Khoá học hóa học'),
(5, 'Biology', 'Khoá học sinh học'),
(6, 'History', 'Khoá học lịch sử'),
(7, 'Geography', 'Khoá học địa lý'),
(8, 'Literature', 'Khoá học văn học'),
(9, 'Music', 'Khoá học âm nhạc'),
(10, 'Art', 'Khoá học mỹ thuật');

SET IDENTITY_INSERT Categories OFF;


-- Bảng Courses
SET IDENTITY_INSERT Courses ON;

INSERT INTO Courses (CourseID, Name, Description, Price, Avatar, Status, StartDate, EndDate, InstructorID, CategoryID)
VALUES
(1, 'C++ Programming', 'Learn C++ programming language', 50.00, 'avatar1.jpg', 'Active', '2023-10-01', '2023-12-01', 1, 1),
(2, 'Recursion in Math', 'Learn recursion in math', 30.00, 'avatar2.jpg', 'Active', '2023-10-01', '2023-12-01', 2, 2),
(3, 'Physics 101', 'Introduction to physics', 50.00, 'avatar1.jpg', 'Active', '2023-10-01', '2023-12-01', 1, 3),
(4, 'Chemistry 101', 'Introduction to chemistry', 30.00, 'avatar2.jpg', 'Active', '2023-10-01', '2023-12-01', 2, 4),
(5, 'Biology 101', 'Introduction to biology', 50.00, 'avatar1.jpg', 'Active', '2023-10-01', '2023-12-01', 1, 5),
(6, 'History 101', 'Introduction to history', 30.00, 'avatar2.jpg', 'Active', '2023-10-01', '2023-12-01', 2, 6),
(7, 'Geography 101', 'Introduction to geography', 50.00, 'avatar1.jpg', 'Active', '2023-10-01', '2023-12-01', 1, 7),
(8, 'Literature 101', 'Introduction to literature', 30.00, 'avatar2.jpg', 'Active', '2023-10-01', '2023-12-01', 2, 8),
(9, 'Music 101', 'Introduction to music', 50.00, 'avatar1.jpg', 'Active', '2023-10-01', '2023-12-01', 1, 9),
(10, 'Art 101', 'Introduction to art', 30.00, 'avatar2.jpg', 'Active', '2023-10-01', '2023-12-01', 2, 10);

SET IDENTITY_INSERT Courses OFF;


-- Bảng CourseContents
SET IDENTITY_INSERT CourseContents ON;

INSERT INTO CourseContents (ContentID, CourseID, ContentDescription)
VALUES
(1, 1, 'Introduction to C++'),
(2, 1, 'Basic syntax of C++'),
(3, 2, 'Introduction to recursion'),
(4, 2, 'Recursion in math'),
(5, 3, 'Introduction to physics'),
(6, 3, 'Basic physics concepts'),
(7, 4, 'Introduction to chemistry'),
(8, 4, 'Basic chemistry concepts'),
(9, 5, 'Introduction to biology'),
(10, 5, 'Basic biology concepts'),
(11, 6, 'Introduction to history'),
(12, 6, 'Basic history concepts'),
(13, 7, 'Introduction to geography'),
(14, 7, 'Basic geography concepts'),
(15, 8, 'Introduction to literature'),
(16, 8, 'Basic literature concepts'),
(17, 9, 'Introduction to music'),
(18, 9, 'Basic music concepts'),
(19, 10, 'Introduction to art'),
(20, 10, 'Basic art concepts');

SET IDENTITY_INSERT CourseContents OFF;


-- Bảng Reviews
SET IDENTITY_INSERT Reviews ON;

INSERT INTO Reviews (ReviewID, CourseID, StudentID, Rating, Comment)
VALUES
(1, 1, 1, 5, 'Great course!'),
(2, 1, 2, 4, 'Good course!'),
(3, 2, 1, 5, 'Great course!'),
(4, 2, 2, 4, 'Good course!'),
(5, 3, 1, 5, 'Great course!'),
(6, 3, 2, 4, 'Good course!'),
(7, 4, 1, 5, 'Great course!'),
(8, 4, 2, 4, 'Good course!'),
(9, 5, 1, 5, 'Great course!'),
(10, 5, 2, 4, 'Good course!');

SET IDENTITY_INSERT Reviews OFF;


-- Bảng Carts
SET IDENTITY_INSERT Carts ON;

INSERT INTO Carts (CartID, StudentID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

SET IDENTITY_INSERT Carts OFF;

-- Bảng CartItems
SET IDENTITY_INSERT CartItems ON;

INSERT INTO CartItems (CartItemID, CartID, CourseID)
VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 1),
(4, 2, 2),
(5, 3, 1),
(6, 3, 2),
(7, 4, 1),
(8, 4, 2),
(9, 5, 1),
(10, 5, 2);

SET IDENTITY_INSERT CartItems OFF;


-- Bảng Orders
SET IDENTITY_INSERT Orders ON;

INSERT INTO Orders (OrderID, StudentID, Status, OrderDate, TotalAmount)
VALUES
(1, 1, 'Paid', '2023-10-01', 100.00),
(2, 2, 'Paid', '2023-10-02', 50.00),
(3, 3, 'Paid', '2023-10-03', 100.00),
(4, 4, 'Paid', '2023-10-04', 50.00),
(5, 5, 'Paid', '2023-10-05', 100.00),
(6, 1, 'Paid', '2023-10-01', 100.00),
(7, 2, 'Paid', '2023-10-02', 50.00),
(8, 3, 'Paid', '2023-10-03', 100.00),
(9, 4, 'Paid', '2023-10-04', 50.00),
(10, 5, 'Paid', '2023-10-05', 100.00);

SET IDENTITY_INSERT Orders OFF;


-- Bảng OrderItems
SET IDENTITY_INSERT OrderItems ON;

INSERT INTO OrderItems (OrderItemID, OrderID, CourseID)
VALUES
(1, 1, 1),
(2, 2, 2);

SET IDENTITY_INSERT OrderItems OFF;


-- Bảng Payments
SET IDENTITY_INSERT Payments ON;

INSERT INTO Payments (PaymentID, OrderID, Amount, PaymentCode, PaymentDate)
VALUES
(1, 1, 100.00, 'PAY123', '2023-10-01'),
(2, 2, 50.00, 'PAY456', '2023-10-02'),
(3, 3, 100.00, 'PAY789', '2023-10-03'),
(4, 4, 50.00, 'PAY101', '2023-10-04'),
(5, 5, 100.00, 'PAY112', '2023-10-05'),
(6, 1, 100.00, 'PAY123', '2023-10-01'),
(7, 2, 50.00, 'PAY456', '2023-10-02'),
(8, 3, 100.00, 'PAY789', '2023-10-03'),
(9, 4, 50.00, 'PAY101', '2023-10-04'),
(10, 5, 100.00, 'PAY112', '2023-10-05');

SET IDENTITY_INSERT Payments OFF;


-- Bảng Coupons
SET IDENTITY_INSERT Coupons ON;

INSERT INTO Coupons (CouponID, Title, Value, DiscountType, ExpiryDate, Conditions)
VALUES
(1, '50% off', 50.00, 'Percentage', '2024-10-01', '50% off for all courses'),
(2, '10% off', 10.00, 'Percentage', '2024-10-02', '10% off for all courses'),
(3, '100% off', 100.00, 'Percentage', '2024-10-03', '100% off for all courses'),
(4, '20% off', 20.00, 'Percentage', '2024-10-04', '20% off for all courses'),
(5, '30% off', 30.00, 'Percentage', '2024-10-05', '30% off for all courses'),
(6, '40% off', 40.00, 'Percentage', '2024-10-06', '40% off for all courses'),
(7, '50% off', 50.00, 'Percentage', '2024-10-07', '50% off for all courses'),
(8, '60% off', 60.00, 'Percentage', '2024-10-08', '60% off for all courses'),
(9, '70% off', 70.00, 'Percentage', '2024-10-09', '70% off for all courses'),
(10, '80% off', 80.00, 'Percentage', '2024-10-10', '80% off for all courses');

SET IDENTITY_INSERT Coupons OFF;



-- Bảng Edits
SET IDENTITY_INSERT Edits ON;

INSERT INTO Edits (EditID, AdminID, EditTime, CourseID)
VALUES
    (1, 1, '2023-10-01 10:00:00', 1),
    (2, 1, '2023-10-02 10:00:00', 2),
    (3, 1, '2023-10-03 10:00:00', 3),
    (4, 1, '2023-10-04 10:00:00', 4),
    (5, 1, '2023-10-05 10:00:00', 5),
    (6, 1, '2023-10-06 10:00:00', 6),
    (7, 1, '2023-10-07 10:00:00', 7),
    (8, 1, '2023-10-08 10:00:00', 8),
    (9, 1, '2023-10-09 10:00:00', 9),
    (10, 1, '2023-10-10 10:00:00', 10),
    (11, 2, '2023-10-01 10:00:00', 1),
    (12, 2, '2023-10-02 10:00:00', 2),
    (13, 2, '2023-10-03 10:00:00', 3),
    (14, 2, '2023-10-04 10:00:00', 4),
    (15, 2, '2023-10-05 10:00:00', 5),
    (16, 2, '2023-10-06 10:00:00', 6),
    (17, 2, '2023-10-07 10:00:00', 7),
    (18, 2, '2023-10-08 10:00:00', 8),
    (19, 2, '2023-10-09 10:00:00', 9),
    (20, 2, '2023-10-10 10:00:00', 10);

SET IDENTITY_INSERT Edits OFF;



-------------------------------- CÂU LỆNH TRUY VẤN --------------------------------

-- Lấy danh sách khóa học trong giỏ hàng với CartID = 1
SELECT Courses.*
FROM CartItems
JOIN Courses ON CartItems.CourseID = Courses.CourseID
WHERE CartItems.CartID = 1;

-- Lấy danh sách khóa học trong đơn đặt hàng với OrderID = 1
SELECT Courses.*
FROM OrderItems
JOIN Courses ON OrderItems.CourseID = Courses.CourseID
WHERE OrderItems.OrderID = 1;


--2.1
--a Thủ tục Insert
-- Mô tả thủ tục: Thủ tục này dùng để thêm một khóa học mới vào bảng Courses.
--Sử dụng khi cần thêm khóa học mới vào danh sách khóa học. Thủ tục này bao gồm việc nhận thông tin khóa học và chèn vào bảng.
-- Input:
-- @CourseName NVARCHAR(100)
-- @Description NVARCHAR(255)
-- @Price DECIMAL(10, 2)
-- Output: Không có

GO

CREATE PROCEDURE InsertCourse
    @CourseName NVARCHAR(100),
    @Description NVARCHAR(255),
    @Price DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO Courses (Name, Description, Price)
    VALUES (@CourseName, @Description, @Price);
END;

EXEC InsertCourse @CourseName = 'Hệ cơ sở dữ liệu', @Description = 'Mô tả về HCSDL...', @Price = 100.00;



--b
-- Thủ tục UPDATE:
-- Mô tả thủ tục: Thủ tục này dùng để cập nhật thông tin của một khóa học trong bảng Courses.
--Sử dụng khi cần chỉnh sửa thông tin khóa học đã tồn tại.
-- Input:
-- @CourseID INT
-- @CourseName NVARCHAR(100)
-- @Description NVARCHAR(255)
-- @Price DECIMAL(10, 2)
-- Output: Không có

GO
CREATE PROCEDURE UpdateCourse
    @CourseID INT,
    @CourseName NVARCHAR(100),
    @Description NVARCHAR(255),
    @Price DECIMAL(10, 2)
AS
BEGIN
    UPDATE Courses
    SET Name = @CourseName,
        Description = @Description,
        Price = @Price
    WHERE CourseID = @CourseID;
END;


EXEC UpdateCourse @CourseID = 1, @CourseName = 'Lập trình nâng cao', @Description = 'Mô tả mới về khoá học', @Price = 100.00;


--c
-- Thủ tục DELETE:

-- Mô tả thủ tục: Thủ tục này dùng để xóa một khóa học khỏi bảng Courses.
--Sử dụng khi cần loại bỏ khóa học không còn cung cấp.
-- Input:
-- @CourseID INT
-- Output: Không có


GO
CREATE PROCEDURE DeleteCourse
    @CourseID INT
AS
BEGIN
    DELETE FROM Courses
    WHERE CourseID = @CourseID;
END;


EXEC DeleteCourse @CourseID = 1;



--2.2 TRIGGER

-- a. Trigger 1:
-- Mô tả trigger: Trigger này dùng để tự động cập nhật tổng giá trị đơn hàng
-- trong bảng Orders khi có sự thay đổi về sản phẩm trong bảng OrderItems.
-- Được kích hoạt sau khi có thao tác INSERT, UPDATE, DELETE trên bảng OrderItems.
-- Trigger này bao gồm việc tính lại tổng giá trị đơn hàng và cập nhật vào bảng Orders.

GO
CREATE TRIGGER trg_UpdateOrderTotal
ON OrderItems
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @OrderID INT;

    -- Lấy ID đơn hàng bị ảnh hưởng (OrderID) từ bảng INSERTED hoặc DELETED
    SELECT @OrderID = COALESCE(INSERTED.OrderID, DELETED.OrderID)
    FROM INSERTED
    --Nối đầy đủ hai bảng INSERTED và DELETED dựa trên OrderID để đảm bảo rằng @OrderID luôn được lấy dù là thao tác INSERT, UPDATE hay DELETE
    FULL OUTER JOIN DELETED ON INSERTED.OrderID = DELETED.OrderID;

    -- Cập nhật tổng giá trị đơn hàng
    UPDATE Orders
    SET TotalAmount = (
        SELECT SUM(Courses.Price)
        FROM OrderItems
        JOIN Courses ON OrderItems.CourseID = Courses.CourseID
        WHERE OrderID = @OrderID
    )
    WHERE OrderID = @OrderID;
END;


-- b. Trigger 2:
--Mô tả trigger: Trigger này dùng để ghi lại lịch sử chỉnh sửa khóa học vào bảng Edits khi có cập nhật trên bảng Courses.
--Được kích hoạt sau khi UPDATE trên bảng Courses. Trigger bao gồm việc lưu thông tin khóa học
-- đã được thay đổi, ai thay đổi và thời gian thay đổi.

GO
CREATE TRIGGER trg_LogCourseEdits
ON Courses
AFTER UPDATE
AS
BEGIN
    INSERT INTO Edits (CourseID, AdminID, EditTime)
    SELECT
        INSERTED.CourseID,
        SYSTEM_USER, -- Hoặc trường UserID nếu có
        GETDATE()
    FROM INSERTED;
END;
GO

--c. Trigger 3
--Cập nhật trạng thái đơn hàng tự động
--Mô tả: Trigger này tự động chuyển trạng thái đơn hàng thành "Đã thanh toán" khi có bản ghi thanh toán mới.
CREATE TRIGGER trg_UpdateOrderStatusOnPayment
ON Payments
AFTER INSERT
AS
BEGIN
    UPDATE Orders
    SET Status = 'Paid'
    WHERE OrderID IN (SELECT OrderID FROM inserted);
END;

--d. Trigger 4
--Tự động cập nhật trạng thái của khóa học
--Mô tả: Trigger tự động cập nhật trạng thái của khóa học trong bảng Courses thành "Finished" khi EndDate của khóa học đã qua ngày hiện tại.
GO
CREATE TRIGGER trg_UpdateCourseStatus
ON Courses
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Courses
    SET Status = 'Finished'
    WHERE EndDate < GETDATE() AND Status <> 'Finished';
END;


--2.3 Thủ tục

--2.3a
-- Mô tả thủ tục: Thủ tục này dùng để lấy danh sách các khóa học trong giỏ hàng của một người dùng.
-- Sử dụng khi cần hiển thị các khóa học mà người dùng đã thêm vào giỏ hàng.
-- Thủ tục này bao gồm việc truy vấn bảng CartItems và Courses để lấy thông tin khóa học.
--Input:
-- @UserID INT
-- Output:
-- Danh sách các khóa học trong giỏ hàng của người dùng

GO
CREATE PROCEDURE GetCoursesInCart
    @UserID INT
AS
BEGIN
    SELECT Courses.*
    FROM CartItems
    JOIN Carts ON CartItems.CartID = Carts.CartID
    JOIN Courses ON CartItems.CourseID = Courses.CourseID
    WHERE Carts.StudentID = @UserID;
END;
GO

EXEC GetCoursesInCart @UserID = 1;




--2.3 Thủ tục
-- Mô tả thủ tục 1: Thủ tục này dùng để lấy danh sách các khóa học trong một đơn đặt hàng.
-- Sử dụng khi cần hiển thị các khóa học mà người dùng đã mua trong một đơn đặt hàng cụ thể.
-- Thủ tục này bao gồm việc truy vấn bảng OrderItems và Courses để lấy thông tin khóa học.
-- Input:
-- @OrderID INT
-- Output:
-- Danh sách các khóa học trong đơn đặt hàng

GO
CREATE PROCEDURE GetCoursesInOrder
    @OrderID INT
AS
BEGIN
    SELECT Courses.*
    FROM OrderItems
    JOIN Courses ON OrderItems.CourseID = Courses.CourseID
    WHERE OrderItems.OrderID = @OrderID;
END;
GO

EXEC GetCoursesInOrder @OrderID = 1;






--.Thủ tục 2: Xoá sinh viên và các dữ liệu liên quan
--Mô tả: Thủ tục này xoá sinh viên dựa trên StudentID và các dữ liệu liên quan (giỏ hàng, đơn hàng, đánh giá).
--Input:
--•	@ StudentID INT
--Output:
--•	Không có



GO
CREATE PROCEDURE DeleteStudent
    @StudentID INT
AS
BEGIN
    DELETE FROM Reviews WHERE StudentID = @StudentID;
    DELETE FROM CartItems WHERE CartID IN (SELECT CartID FROM Carts WHERE StudentID = @StudentID);
    DELETE FROM Carts WHERE StudentID = @StudentID;
    DELETE FROM Orders WHERE StudentID = @StudentID;
    DELETE FROM Guardians WHERE StudentID = @StudentID;
    DELETE FROM Students WHERE StudentID = @StudentID;
END;

EXEC DeleteStudent @StudentID = 5;




-- Thủ tục 3: Lấy danh sách khóa học theo danh mục
-- Mô tả: Thủ tục trả về danh sách các khóa học thuộc một danh mục nhất định.
-- Input:
-- •	@CategoryID INT
-- Output:
-- •	Danh sách các khóa học trong cùng 1 danh mục
GO
CREATE PROCEDURE GetCoursesByCategory
    @CategoryID INT
AS
BEGIN
    SELECT CourseID, Name, Description, Price, Status
    FROM Courses
    WHERE CategoryID = @CategoryID;
END;

EXEC GetCoursesByCategory @CategoryID = 1;



-- 2.4 HÀM

-- a. Hàm 1
-- Mô tả hàm: Hàm này dùng để tính tổng số lượng khóa học trong một đơn đặt hàng.
-- Sử dụng khi cần biết tổng số lượng khóa học mà người dùng đã mua trong một đơn đặt hàng cụ thể.
-- Hàm này bao gồm việc truy vấn bảng OrderItems để tính tổng số lượng khóa học.
-- Input:
-- @OrderID INT
-- Output:
-- Tổng số lượng khóa học trong đơn đặt hàng

GO
CREATE FUNCTION GetTotalCoursesInOrder
(
    @OrderID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @TotalCourses INT;

    SELECT @TotalCourses = COUNT(*)
    FROM OrderItems
    WHERE OrderID = @OrderID;

    RETURN @TotalCourses;
END;
GO

SELECT dbo.GetTotalCoursesInOrder(1);

-- b. Hàm 2
-- Mô tả hàm: Hàm này dùng để lấy tổng giá trị của một đơn đặt hàng.
-- Sử dụng khi cần biết tổng giá trị mà người dùng phải trả cho một đơn đặt hàng cụ thể.
-- Hàm này bao gồm việc truy vấn bảng OrderItems và Courses để tính tổng giá trị đơn đặt hàng.
-- Input:
-- @OrderID INT
-- Output:
-- Tổng giá trị của đơn đặt hàng

GO
CREATE FUNCTION GetTotalOrderValue
(
    @OrderID INT
)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @TotalValue DECIMAL(18, 2);

    SELECT @TotalValue = SUM(Courses.Price)
    FROM OrderItems
    JOIN Courses ON OrderItems.CourseID = Courses.CourseID
    WHERE OrderID = @OrderID;

    RETURN @TotalValue;
END;
GO

SELECT dbo.GetTotalOrderValue(1);




--c.Hàm 3: Lấy danh sách sản phẩm theo giá
--Mô tả: Hàm trả về danh sách sản phẩm có giá nằm trong khoảng được chỉ định.
--Input:
--•	@MinPrice DECIMAL(10,2)
--•	@MaxPrice DECIMAL(10, 2)
--Output:
--•	Danh sách các khóa học trong mức giá

GO
CREATE FUNCTION GetProductsByPriceRange(
    @MinPrice DECIMAL(10, 2),
    @MaxPrice DECIMAL(10, 2)
)
RETURNS TABLE
AS
RETURN (
    SELECT CourseID, Name, Price
    FROM Courses
    WHERE Price BETWEEN @MinPrice AND @MaxPrice
);
GO

SELECT * FROM dbo.GetProductsByPriceRange(10, 40);


--d. Hàm 4
--Tính số lượng khoá học trong một danh mục
--Mô tả: Hàm này trả về số lượng khoá học thuộc một danh mục cụ thể.
--Input:
--•	@ CategoryID INT
--Output:
--•	Số lượng khóa học thuộc cùng danh mục
GO
CREATE FUNCTION CountCoursesInCategory(@CategoryID INT)
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*) FROM Courses WHERE CategoryID = @CategoryID);
END;
GO

SELECT dbo.CountCoursesInCategory(1) AS TotalCourses;
