--------------------------TẠO DATABASE-------------------------
CREATE DATABASE OnlineCourse COLLATE Vietnamese_CI_AI
GO

USE OnlineCourse
--Người dùng hệ thống
CREATE TABLE Users(
    Username_ID INT PRIMARY KEY,
    User_Email VARCHAR(255) UNIQUE,
    User_Phone_Number VARCHAR(10),
    User_Password NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    User_Address NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    User_Image TEXT,
    User_Name NVARCHAR(255) COLLATE Vietnamese_CI_AI,
)

--Admin
CREATE TABLE Admin(
    Admin_ID INT PRIMARY KEY,

    FOREIGN KEY (Admin_ID) REFERENCES Users(Username_ID) ON DELETE CASCADE,
)

-- Giảng viên
CREATE TABLE Teacher(
    Teacher_ID INT PRIMARY KEY,
    Teacher_Description NVARCHAR(255) COLLATE Vietnamese_CI_AI,

    FOREIGN KEY (Teacher_ID) REFERENCES Users(Username_ID) ON DELETE CASCADE,
);

--Giỏ hàng
CREATE TABLE Cart(
    Cart_ID INT PRIMARY KEY,
);

-- Phiếu giảm giá
CREATE TABLE Coupon(
    Coupon_ID INT PRIMARY KEY,
    Coupon_title NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Coupon_Value INT,
    Coupon_Type NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Coupon_Start_Date DATE,
    Coupon_Expiry_Date DATE,
    Coupon_Max_Discount INT,
);

--Học viên
CREATE TABLE Student(
    Student_ID INT PRIMARY KEY,
    Student_Cart_ID INT,

    FOREIGN KEY (Student_Cart_ID) REFERENCES Cart(Cart_ID) ON DELETE CASCADE,
    FOREIGN KEY (Student_ID) REFERENCES Users(Username_ID) ON DELETE CASCADE,
);

-- Bảng danh mục
CREATE TABLE Categories (
    Categories_ID INT PRIMARY KEY,
    Categories_Name NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Categories_Description NVARCHAR(255) COLLATE Vietnamese_CI_AI,
);


--Khoá học
CREATE TABLE Course(
    Course_ID INT PRIMARY KEY,
    Course_Name NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Course_Status NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Course_Description NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Course_Price INT,
    Course_Image TEXT,
    Course_Start_Date DATE,
    Course_End_Date DATE,
    Course_Categories_ID INT,

    FOREIGN KEY (Course_Categories_ID) REFERENCES Categories(Categories_ID) ON DELETE CASCADE,
);


-- Bảng chỉnh sửa
CREATE TABLE Edit (
    Edit_ID INT PRIMARY KEY,
    Edit_Time DATETIME DEFAULT CURRENT_TIMESTAMP,
    Edit_Content NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Edit_Admin_ID INT,
    Edit_Coupon_ID INT,
    EDIT_Course_ID INT,

    FOREIGN KEY (Edit_Admin_ID) REFERENCES Admin(Admin_ID) ON DELETE CASCADE,
    FOREIGN KEY (Edit_Coupon_ID) REFERENCES Coupon(Coupon_ID) ON DELETE CASCADE,
    FOREIGN KEY (Edit_Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
);

--Giảng viên dạy khoá học
CREATE TABLE Teacher_Course(
    Teacher_ID INT,
    Course_ID INT,

    PRIMARY KEY (Teacher_ID, Course_ID),
    FOREIGN KEY (Teacher_ID) REFERENCES Teacher(Teacher_ID) ON DELETE CASCADE,
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
);

--Khoá học áp dụng phiếu giảm giá
CREATE TABLE Course_Coupon(
    Course_ID INT,
    Coupon_ID INT,
    PRIMARY KEY (Course_ID, Coupon_ID),

    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
    FOREIGN KEY (Coupon_ID) REFERENCES Coupon(Coupon_ID) ON DELETE CASCADE,
);


--Khoá học được thêm vào giỏ hàng
CREATE TABLE Course_Cart(
    Course_ID INT,
    Cart_ID INT,
    PRIMARY KEY (Course_ID, Cart_ID),

    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
    FOREIGN KEY (Cart_ID) REFERENCES Cart(Cart_ID) ON DELETE CASCADE,
);


--Khoá học có học viên
CREATE TABLE Course_Student(
    Course_ID INT,
    Student_ID INT,
    PRIMARY KEY (Course_ID, Student_ID),

    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
);


--Phương thức thanh toán
CREATE TABLE Payment_Method(
    Payment_Method_ID INT PRIMARY KEY,
    Payer_Name NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Payment_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
);

--Momo
CREATE TABLE Momo(
    Momo_ID INT PRIMARY KEY,
    Momo_Phone_Number VARCHAR(10),

    FOREIGN KEY (Momo_ID) REFERENCES Payment_Method(Payment_Method_ID) ON DELETE CASCADE,
);

--Internet banking
CREATE TABLE Internet_Banking(
    Internet_Banking_ID INT PRIMARY KEY,
    Internet_Banking_Bank_Name NVARCHAR(255) COLLATE Vietnamese_CI_AI,

    FOREIGN KEY (Internet_Banking_ID) REFERENCES Payment_Method(Payment_Method_ID) ON DELETE CASCADE,
);

--Visa
CREATE TABLE Visa(
    Visa_ID INT PRIMARY KEY,
    Visa_Card_Number VARCHAR(16),
    Visa_Expiry_Date DATE,

    FOREIGN KEY (Visa_ID) REFERENCES Payment_Method(Payment_Method_ID) ON DELETE CASCADE,
);

--Đơn hàng
CREATE TABLE Orders (
    Orders_ID INT PRIMARY KEY,
    Orders_Payment_Status NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Orders_Time DATETIME DEFAULT CURRENT_TIMESTAMP,
    Payment_ID INT,
    Student_ID INT,

    FOREIGN KEY (Payment_ID) REFERENCES Payment_Method(Payment_Method_ID) ON DELETE CASCADE,
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
);

--Khoá học được thêm vào đơn hàng
CREATE TABLE Course_Order(
    Course_ID INT,
    Order_ID INT,
    PRIMARY KEY (Course_ID, Order_ID),

    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
    FOREIGN KEY (Order_ID) REFERENCES Orders(Orders_ID) ON DELETE CASCADE,
);

--Đánh giá
CREATE TABLE Reviews (
    Reviews_ID INT,
    Course_ID INT,
    Reviews_Score INT,
    Reviews_Content NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Student_ID INT,
    PRIMARY KEY (Reviews_ID, Course_ID),

    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE,
    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
);


--Người đại diện
CREATE TABLE Guardians(
    Guardians_ID INT,
    Student_ID INT,
    Guardians_Name NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Guardians_Email VARCHAR(255) UNIQUE,
    Guardians_Phone_Number VARCHAR(10),
    PRIMARY KEY (Guardians_ID, Student_ID),

    FOREIGN KEY (Student_ID) REFERENCES Student(Student_ID) ON DELETE CASCADE,
)

--Chương
CREATE TABLE Chapter(
    Chapter_Name NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Course_ID INT,
    PRIMARY KEY (Chapter_Name, Course_ID),
    FOREIGN KEY (Course_ID) REFERENCES Course(Course_ID) ON DELETE CASCADE
);

--Bài học
CREATE TABLE Lesson (
    Lesson_Order INT,
    Course_ID INT,
    Chapter_Name NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Lesson_Title NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Lesson_Content NVARCHAR(MAX) COLLATE Vietnamese_CI_AI,
    Lesson_Duration INT,
    PRIMARY KEY (Lesson_Order, Course_ID, Chapter_Name),
    FOREIGN KEY (Chapter_Name, Course_ID) REFERENCES Chapter(Chapter_Name, Course_ID) ON DELETE CASCADE
)

--Bài tập
CREATE TABLE Exercise(
    Exercise_Order INT,
    Lesson_Order INT,
    Course_ID INT,
    Chapter_Name NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Exercise_Title NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Exercise_Solution NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Exercise_Number_Of_Correct_Answers INT,
    Exercise_Content NVARCHAR(MAX) COLLATE Vietnamese_CI_AI,

    PRIMARY KEY (Exercise_Order, Lesson_Order, Course_ID, Chapter_Name),

    FOREIGN KEY (Lesson_Order, Course_ID, Chapter_Name) REFERENCES Lesson(Lesson_Order, Course_ID, Chapter_Name) ON DELETE CASCADE,
)

--Tài liệu
CREATE TABLE Document(
    Document_ID INT PRIMARY KEY,
    Course_ID INT,
    Chapter_Name NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Document_Author NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Document_Title NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Document_Size INT,
    Document_Type VARCHAR(255),
    Document_Content NVARCHAR(MAX) COLLATE Vietnamese_CI_AI,
    FOREIGN KEY (Chapter_Name, Course_ID) REFERENCES Chapter(Chapter_Name, Course_ID) ON DELETE CASCADE
)

--Bài kiểm tra
CREATE TABLE Test(
    Test_Order INT,
    Chapter_Name NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Course_ID INT,
    Test_Number_Of_Questions INT,
    Test_Solution NVARCHAR(255) COLLATE Vietnamese_CI_AI,
    Test_TakenTimes INT,
    Test_Number_Of_Correct_Answers INT,
    Test_Content NVARCHAR(MAX) COLLATE Vietnamese_CI_AI,

    PRIMARY KEY (Test_Order, Chapter_Name, Course_ID),

    FOREIGN KEY (Chapter_Name, Course_ID) REFERENCES Chapter(Chapter_Name, Course_ID) ON DELETE CASCADE
)




--------------------------INSERT DỮ LIỆU-------------------------
INSERT INTO Users(Username_ID, User_Email, User_Phone_Number, User_Password, User_Address, User_Image, User_Name)
VALUES
   (1, 'minhnhut.tran@gmail.com', '0941063485', N'abc12345', N'Tp. Hồ Chí Minh', 'nhut_image.jpg', N'Trần Minh Nhựt'),
   (2, 'hoa.le@gmail.com', '0973456789', N'hoa_9876', N'Hà Nội', 'hoa_image.jpg', N'Lê Thị Hoa'),
   (3, 'anh.nguyen@gmail.com', '0932123456', N'nguyen123', N'Đà Nẵng', 'anh_image.jpg', N'Nguyễn Văn Anh'),
   (4, 'huong.pham@gmail.com', '0912345678', N'huong_456', N'Hải Phòng', 'huong_image.jpg', N'Phạm Thị Hương'),
   (5, 'long.nguyen@gmail.com', '0967890123', N'long_pass1', N'Cần Thơ', 'long_image.jpg', N'Nguyễn Thành Long'),
   (6, 'khanh.le@gmail.com', '0923456781', N'khanh!2023', N'Huế', 'khanh_image.jpg', N'Lê Thị Khánh'),
   (7, 'bao.vo@gmail.com', '0981234567', N'bao_pass123', N'Tp. Hồ Chí Minh', 'bao_image.jpg', N'Võ Bảo Khánh'),
   (8, 'lan.do@gmail.com', '0945678901', N'lan_7890', N'Hà Nội', 'lan_image.jpg', N'Đỗ Thị Lan'),
   (9, 'son.pham@gmail.com', '0916782345', N'son_abc987', N'Đà Nẵng', 'son_image.jpg', N'Phạm Quang Sơn'),
   (10, 'tien.nguyen@gmail.com', '0937894561', N'tien_secure', N'Hải Phòng', 'tien_image.jpg', N'Nguyễn Minh Tiến'),
   (11, 'thao.nguyen@gmail.com', '0901234567', N'thao!2345', N'Tp. Hồ Chí Minh', 'thao_image.jpg', N'Nguyễn Thị Thảo'),
   (12, 'trung.le@gmail.com', '0912345679', N'trung1234', N'Hà Nội', 'trung_image.jpg', N'Lê Minh Trung'),
   (13, 'minh.tung@gmail.com', '0932345678', N'minhtung!56', N'Đà Nẵng', 'minhtung_image.jpg', N'Nguyễn Minh Tùng'),
   (14, 'thuy.pham@gmail.com', '0965432109', N'thuy!789', N'Hải Phòng', 'thuy_image.jpg', N'Phạm Thị Thùy'),
   (15, 'hoang.nguyen@gmail.com', '0909876543', N'hoang!1234', N'Cần Thơ', 'hoang_image.jpg', N'Nguyễn Hoàng Sơn'),
   (16, 'lan.pham@gmail.com', '0941234560', N'lan1234', N'Huế', 'lan_image.jpg', N'Phạm Thị Lan'),
   (17, 'hieu.nguyen@gmail.com', '0934567890', N'hieu!8901', N'Tp. Hồ Chí Minh', 'hieu_image.jpg', N'Nguyễn Hữu Hiếu'),
   (18, 'nhung.dang@gmail.com', '0975678901', N'nhung_2345', N'Hà Nội', 'nhung_image.jpg', N'Đặng Thị Nhung'),
   (19, 'duy.nguyen@gmail.com', '0923456789', N'duy1234pass', N'Đà Nẵng', 'duy_image.jpg', N'Nguyễn Minh Duy'),
   (20, 'vutranh@gmail.com', '0917896543', N'vutran123', N'Hải Phòng', 'vutran_image.jpg', N'Trần Vũ');


INSERT INTO Admin(Admin_ID)
VALUES (1), (2), (3);

INSERT INTO Teacher(Teacher_ID, Teacher_Description)
VALUES
    (4, N'Giáo viên Toán với 10 năm kinh nghiệm giảng dạy tại các trường chuyên.'),
    (5, N'Giáo viên Văn, chuyên nghiên cứu và giảng dạy văn học hiện đại Việt Nam.'),
    (6, N'Giáo viên Lý, có bằng Thạc sĩ về Vật lý ứng dụng từ trường Đại học Bách khoa.'),
    (7, N'Giáo viên Hóa, từng giành giải nhất kỳ thi Hóa học quốc gia.'),
    (8, N'Giáo viên Sinh, có kinh nghiệm giảng dạy tại trường THPT chuyên.');

INSERT INTO Cart(Cart_ID )
VALUES (1), (2), (3)

INSERT INTO Student(Student_ID, Student_Cart_ID)
VALUES (9, NULL), (10, NULL), (11, NULL), (12, NULL), (13, NULL), (14, NULL), (15, NULL), (16, NULL), (17, NULL), (18, 1), (19, 2), (20, 3);

INSERT INTO Coupon(Coupon_ID, Coupon_Title, Coupon_Value, Coupon_Type, Coupon_Start_Date, Coupon_Expiry_Date, Coupon_Max_Discount)
VALUES
    (1, N'Giảm giá khai trương', 10, 'Percent', '2023-01-01', '2023-12-31', 30),
    (2, N'Ưu đãi khách hàng mới', 20, 'Percent', '2023-02-01', '2023-12-31', 40),
    (3, N'Giảm giá mùa hè', 20, 'Percent', '2023-06-01', '2023-08-31', 50),
    (4, N'Giảm giá cuối năm', 20, 'Percent', '2023-11-01', '2023-12-31', 60),
    (5, N'Ưu đãi VIP', 30, 'Fixed', '2023-01-01', '2024-01-01', 40);

INSERT INTO Categories(Categories_ID, Categories_Name, Categories_Description)
VALUES
    (1, N'Điện tử', N'Các sản phẩm công nghệ như điện thoại, máy tính, và phụ kiện.'),
    (2, N'Thời trang', N'Quần áo, giày dép, và phụ kiện thời trang cho mọi lứa tuổi.'),
    (3, N'Đồ gia dụng', N'Các sản phẩm phục vụ cho nhu cầu hàng ngày trong gia đình.'),
    (4, N'Thực phẩm', N'Thực phẩm tươi sống, đồ uống, và thực phẩm chế biến sẵn.'),
    (5, N'Sách và văn phòng phẩm', N'Sách giáo khoa, tiểu thuyết, và dụng cụ văn phòng.');



INSERT INTO Course(Course_ID, Course_Name, Course_Status, Course_Description, Course_Price, Course_Image, Course_Start_Date, Course_End_Date, Course_Categories_ID)
VALUES
    (1, N'Lập trình Python cơ bản', 'Open', N'Khóa học giúp bạn nắm vững các kiến thức cơ bản về Python.', 500, 'python_basic.jpg', '2024-01-01', '2024-06-30', 1),
    (2, N'Phát triển Web với HTML & CSS', 'Open', N'Khóa học cung cấp kiến thức cơ bản về HTML, CSS để xây dựng website.', 400, 'html_css.jpg', '2024-01-15', '2024-07-15', 1),
    (3, N'Kỹ năng thuyết trình', 'Closed', N'Khóa học giúp nâng cao kỹ năng thuyết trình và giao tiếp hiệu quả.', 300, 'presentation.jpg', '2023-03-01', '2023-09-01', 3),
    (4, N'Thiết kế đồ họa với Photoshop', 'Open', N'Khóa học dạy cách sử dụng Photoshop để thiết kế đồ họa chuyên nghiệp.', 600, 'photoshop.jpg', '2024-02-01', '2024-08-01', 1),
    (5, N'Hướng dẫn sử dụng Excel nâng cao', 'Open', N'Khóa học giúp bạn thành thạo các công cụ nâng cao trong Excel.', 450, 'excel_advanced.jpg', '2024-03-01', '2024-09-01', 3),
    (6, N'Nghệ thuật quản lý thời gian', 'Open', N'Khóa học cung cấp các kỹ thuật quản lý thời gian hiệu quả.', 250, 'time_management.jpg', '2024-01-01', '2024-04-30', 3),
    (7, N'Lập trình Java nâng cao', 'Open', N'Khóa học nâng cao kỹ năng lập trình Java, bao gồm OOP và JavaFX.', 700, 'java_advanced.jpg', '2024-05-01', '2024-12-31', 1),
    (8, N'Tiếng Anh giao tiếp cơ bản', 'Open', N'Khóa học cung cấp các kỹ năng giao tiếp tiếng Anh hàng ngày.', 300, 'english_basic.jpg', '2024-01-01', '2024-06-01', 2),
    (9, N'Marketing căn bản', 'Open', N'Khóa học giới thiệu các khái niệm và công cụ cơ bản trong Marketing.', 500, 'marketing.jpg', '2024-04-01', '2024-09-30', 2),
    (10, N'Phân tích dữ liệu với Python', 'Open', N'Khóa học chuyên sâu về phân tích dữ liệu và trực quan hóa với Python.', 800, 'data_analysis.jpg', '2024-02-01', '2024-08-31', 1);




INSERT INTO Edit(Edit_ID, Edit_Time, Edit_Content, Edit_Admin_ID, Edit_Coupon_ID, Edit_Course_ID)
VALUES
    (1, '2023-05-02', N'Cập nhật nội dung khóa học Python cơ bản.', 1, 1, 1),
    (2, '2024-03-01', N'Thay đổi mức giảm giá cho ưu đãi khách hàng mới.', 2, 2, 8),
    (3, '2021-09-02', N'Chỉnh sửa tiêu đề và mô tả của khóa học thuyết trình.', 3, NULL, 3),
    (4, '2023-12-15', N'Gia hạn ngày hết hạn của mã giảm giá Giảm giá cuối năm.', 1, 4, NULL),
    (5, '2024-02-10', N'Thêm chi tiết bài tập thực hành trong khóa học phân tích dữ liệu.', 2, NULL, 10),
    (6, '2024-01-20', N'Cập nhật hình ảnh mới cho khóa học Marketing căn bản.', 3, NULL, 9),
    (7, '2023-08-05', N'Chỉnh sửa mô tả ưu đãi giảm giá mùa hè.', 1, 3, NULL),
    (8, '2024-04-12', N'Thay đổi ngày bắt đầu của khóa học Excel nâng cao.', 2, NULL, 5),
    (9, '2023-11-30', N'Điều chỉnh mức giảm giá và tối đa hóa ưu đãi VIP.', 3, 5, NULL),
    (10, '2024-03-15', N'Thêm nội dung mới vào khóa học Java nâng cao.', 1, NULL, 7);

INSERT INTO Teacher_Course(Teacher_ID, Course_ID)
VALUES (4, 1), (5, 2), (6, 3);

INSERT INTO Course_Coupon(Course_ID, Coupon_ID)
VALUES (1, 1), (2, 2), (3, 3);

INSERT INTO Course_Cart(Course_ID, Cart_ID)
VALUES (1, 1), (2, 2), (3, 3);

INSERT INTO Course_Student(Course_ID, Student_ID)
VALUES (1, 9), (2, 10), (3, 11), (4, 12), (5, 13), (6, 14), (7, 15), (8, 16), (9, 17), (10, 18);
INSERT INTO Course_Student(Course_ID, Student_ID)
VALUES
    -- Course 1 đã có student 9, thêm 2 student mới
    (1, 10),
    (1, 11),
    (2, 12),
    (2, 13),
    (3, 14),
    (3, 15),
    (4, 16),
    (4, 17),
    (5, 18),
    (5, 19),
    (6, 15),
    (6, 16),
    (7, 17),
    (7, 18),
    (8, 19),
    (8, 20),
    (9, 18),
    (9, 19),
    (10, 19),
    (10, 20);
INSERT INTO Payment_Method(Payment_Method_ID, Payer_Name, Payment_Date)
VALUES
    (1, N'Nguyễn Văn A', '2023-01-15'),
    (2, N'Trần Thị B', '2023-02-10'),
    (3, N'Lê Văn C', '2023-03-05'),
    (4, N'Phạm Thị D', '2023-04-20'),
    (5, N'Đỗ Thanh E', '2023-05-25'),
    (6, N'Hoàng Văn F', '2023-06-15'),
    (7, N'Ngô Thị G', '2023-07-10'),
    (8, N'Bùi Văn H', '2023-08-01'),
    (9, N'Phan Thị I', '2023-09-18'),
    (10, N'Vũ Minh J', '2023-10-05');


INSERT INTO Momo(Momo_ID, Momo_Phone_Number)
VALUES (1, '0123456789'), (2, '0123456788'), (3, '0123456787'),
         (4, '0123456786'), (5, '0123456785'), (6, '0123456784'),
         (7, '0123456783'), (8, '0123456782'), (9, '0123456781'),
         (10, '0123456780');


INSERT INTO Internet_Banking(Internet_Banking_ID, Internet_Banking_Bank_Name)
VALUES (1, 'Argibank'), (2, 'VietcomBank'), (3, 'OCB');

INSERT INTO Visa(Visa_ID, Visa_Card_Number, Visa_Expiry_Date)
VALUES (1, '1234567890123456', '2021-12-01'),
       (2, '1234567890123457', '2022-07-05'),
       (3, '1234567890123458', '2022-11-04'),
            (4, '1234567890123459', '2023-01-01'),
            (5, '1234567890123460', '2023-03-15'),
            (6, '1234567890123461', '2023-05-20'),
            (7, '1234567890123462', '2023-07-25'),
            (8, '1234567890123463', '2023-09-30'),
            (9, '1234567890123464', '2023-11-10'),
            (10, '1234567890123465', '2024-01-01');

INSERT INTO Orders(Orders_ID, Orders_Payment_Status, Orders_Time, Payment_ID, Student_ID)
VALUES
    (1, 'Paid', '2023-01-15', 1, 9),
    (2, 'Paid', '2023-02-10', 2, 10),
    (3, 'Paid', '2023-03-05', 3, 11),
    (4, 'Paid', '2023-04-20', 4, 12),
    (5, 'Paid', '2023-05-25', 5, 13),
    (6, 'Paid', '2023-06-15', 6, 14),
    (7, 'Paid', '2023-07-10', 7, 15),
    (8, 'Paid', '2023-08-01', 8, 16),
    (9, 'Paid', '2023-09-18', 9, 17),
    (10, 'Paid', '2023-10-05', 10, 18);

INSERT INTO Course_Order(Course_ID, Order_ID)
VALUES (1, 1), (2, 2), (3, 3);

INSERT INTO Reviews(Reviews_ID, Course_ID, Reviews_Score, Reviews_Content, Student_ID)
VALUES
    (1, 1, 5, N'Khóa học rất dễ hiểu, nội dung rõ ràng và bổ ích.', 10),
    (2, 2, 4, N'Giảng viên nhiệt tình, nhưng cần thêm ví dụ thực tế.', 11),
    (3, 3, 3, N'Khóa học khá ổn, nhưng thời lượng hơi dài.', 12),
    (4, 4, 5, N'Rất hài lòng! Nội dung phù hợp và ứng dụng thực tế tốt.', 14),
    (5, 5, 4, N'Hướng dẫn dễ hiểu, nhưng bài tập hơi ít.', 13),
    (6, 6, 5, N'Khóa học tuyệt vời! Tôi đã cải thiện đáng kể kỹ năng của mình.', 14),
    (7, 7, 3, N'Khóa học khá khó, cần bổ sung thêm tài liệu hướng dẫn.', 15),
    (8, 8, 4, N'Giảng viên giảng bài hay, nhưng tốc độ hơi nhanh.', 16),
    (9, 9, 5, N'Rất đáng giá tiền, kiến thức áp dụng được ngay.', 17),
    (10, 10, 4, N'Khóa học tốt nhưng cần thêm các buổi thực hành.', 18);
INSERT INTO Reviews(Reviews_ID, Course_ID, Reviews_Score, Reviews_Content, Student_ID)
VALUES
    (11, 1, 5, N'Khóa học cung cấp kiến thức rất chi tiết và dễ hiểu', 12),
    (12, 1, 4, N'Giảng viên nhiệt tình, tài liệu phong phú', 13),
    (13, 1, 5, N'Bài tập thực hành giúp tôi hiểu sâu hơn về Python', 14),
    (14, 1, 3, N'Khóa học tốt nhưng cần thêm nhiều ví dụ thực tế hơn', 15);


INSERT INTO Guardians(Guardians_ID, Student_ID, Guardians_Name, Guardians_Email, Guardians_Phone_Number)
VALUES
    (1, 11, N'Nguyễn Văn A', 'guardian_a@gmail.com', '0945123456'),
    (2, 12, N'Trần Thị B', 'guardian_b@gmail.com', '0932456789'),
    (3, 13, N'Lê Văn C', 'guardian_c@gmail.com', '0912345678'),
    (4, 14, N'Phạm Thị D', 'guardian_d@gmail.com', '0923456781'),
    (5, 15, N'Đỗ Thanh E', 'guardian_e@gmail.com', '0967891234'),
    (6, 16, N'Hoàng Văn F', 'guardian_f@gmail.com', '0982345671'),
    (7, 17, N'Ngô Thị G', 'guardian_g@gmail.com', '0971234568'),
    (8, 18, N'Bùi Văn H', 'guardian_h@gmail.com', '0956781234'),
    (9, 19, N'Phan Thị I', 'guardian_i@gmail.com', '0903456782'),
    (10, 20, N'Vũ Minh J', 'guardian_j@gmail.com', '0934567890');


INSERT INTO Chapter(Chapter_Name, Course_ID)
VALUES
    (N'Giới thiệu Python', 1),
    (N'Cơ bản về HTML và CSS', 2),
    (N'Kỹ năng thuyết trình hiệu quả', 3),
    (N'Cách sử dụng Photoshop cơ bản', 4),
    (N'Hàm và công thức trong Excel', 5),
    (N'Quản lý thời gian trong công việc', 6),
    (N'Java nâng cao: OOP và JavaFX', 7),
    (N'Giao tiếp tiếng Anh hàng ngày', 8),
    (N'Nguyên lý cơ bản trong Marketing', 9),
    (N'Phân tích dữ liệu nâng cao với Python', 10);
INSERT INTO Chapter(Chapter_Name, Course_ID)
VALUES
    (N'Cấu trúc dữ liệu trong Python', 1),
    (N'Lập trình hướng đối tượng với Python', 1),
    (N'Xử lý File và Exception', 1),
    (N'Làm việc với Database', 1);


INSERT INTO Lesson(Lesson_Order, Course_ID, Chapter_Name, Lesson_Title, Lesson_Content, Lesson_Duration)
VALUES
    (1, 1, N'Giới thiệu Python', N'Lập trình cơ bản với Python', N'Học cách cài đặt Python và viết các chương trình đầu tiên', 30),
    (2, 2, N'Cơ bản về HTML và CSS', N'Tạo trang web đầu tiên với HTML và CSS', N'Hướng dẫn xây dựng giao diện web cơ bản', 40),
    (3, 3, N'Kỹ năng thuyết trình hiệu quả', N'Làm chủ kỹ năng thuyết trình', N'Giới thiệu các phương pháp thuyết trình hiệu quả', 50),
    (4, 4, N'Cách sử dụng Photoshop cơ bản', N'Các công cụ cơ bản trong Photoshop', N'Hướng dẫn sử dụng công cụ cắt, chỉnh sửa hình ảnh', 60),
    (5, 5, N'Hàm và công thức trong Excel', N'Sử dụng công thức trong Excel', N'Giới thiệu các hàm và công thức phổ biến trong Excel', 45),
    (6, 6, N'Quản lý thời gian trong công việc', N'Quản lý công việc và thời gian hiệu quả', N'Các phương pháp để quản lý công việc hàng ngày', 35),
    (7, 7, N'Java nâng cao: OOP và JavaFX', N'Lập trình Java với OOP và JavaFX', N'Khám phá lập trình hướng đối tượng và giao diện người dùng', 55),
    (8, 8, N'Giao tiếp tiếng Anh hàng ngày', N'Tiếng Anh giao tiếp trong cuộc sống', N'Học các cụm từ thông dụng và cách giao tiếp hiệu quả', 40),
    (9, 9, N'Nguyên lý cơ bản trong Marketing', N'Marketing căn bản cho người mới bắt đầu', N'Tìm hiểu các nguyên lý cơ bản trong marketing', 50),
    (10, 10, N'Phân tích dữ liệu nâng cao với Python', N'Phân tích dữ liệu với Python và Pandas', N'Hướng dẫn sử dụng Python để phân tích dữ liệu lớn', 60);
INSERT INTO Lesson(Lesson_Order, Course_ID, Chapter_Name, Lesson_Title, Lesson_Content, Lesson_Duration)
VALUES
    (2, 1, N'Cấu trúc dữ liệu trong Python', N'List và Tuple', N'Tìm hiểu về cách sử dụng List và Tuple trong Python', 45),
    (3, 1, N'Cấu trúc dữ liệu trong Python', N'Dictionary và Set', N'Học về Dictionary và Set trong Python', 40),

    (4, 1, N'Lập trình hướng đối tượng với Python', N'Class và Object', N'Giới thiệu về Class và Object trong Python', 50),
    (5, 1, N'Lập trình hướng đối tượng với Python', N'Inheritance và Polymorphism', N'Tìm hiểu về tính kế thừa và đa hình', 55),

    (6, 1, N'Xử lý File và Exception', N'Đọc và ghi file', N'Các thao tác với file trong Python', 35),
    (7, 1, N'Xử lý File và Exception', N'Xử lý ngoại lệ', N'Cách xử lý các exception trong Python', 40),

    (8, 1, N'Làm việc với Database', N'Kết nối Database', N'Học cách kết nối Python với các loại database', 45),
    (9, 1, N'Làm việc với Database', N'Thao tác CRUD', N'Thực hiện các thao tác CRUD với database', 50);


INSERT INTO Exercise(Exercise_Order, Lesson_Order, Course_ID, Chapter_Name, Exercise_Title, Exercise_Solution, Exercise_Number_Of_Correct_Answers, Exercise_Content)
VALUES
   (1, 1, 1, N'Giới thiệu Python', N'Bài tập: In ra câu chào', N'Sử dụng lệnh print để in ra câu chào', 1, N'Viết chương trình Python để in ra "Hello, World!"'),
   (2, 2, 2, N'Cơ bản về HTML và CSS', N'Bài tập: Tạo trang web cơ bản', N'Sử dụng HTML và CSS để tạo một trang web cơ bản', 2, N'Tạo một trang HTML với tiêu đề và đoạn văn bản.'),
   (3, 3, 3, N'Kỹ năng thuyết trình hiệu quả', N'Bài tập: Thực hành thuyết trình', N'Luyện tập thuyết trình trước gương và ghi âm lại', 3, N'Thực hiện một bài thuyết trình 5 phút về một chủ đề yêu thích.'),
   (4, 4, 4, N'Cách sử dụng Photoshop cơ bản', N'Bài tập: Chỉnh sửa ảnh cơ bản', N'Sử dụng công cụ cắt và thay đổi kích thước ảnh', 4, N'Chỉnh sửa một bức ảnh để cắt bỏ phần không cần thiết và thay đổi kích thước.'),
   (5, 5, 5, N'Hàm và công thức trong Excel', N'Bài tập: Sử dụng hàm SUM và AVERAGE', N'Tính tổng và trung bình của một dãy số', 5, N'Sử dụng hàm SUM và AVERAGE để tính tổng và trung bình của một cột dữ liệu.'),
   (6, 6, 6, N'Quản lý thời gian trong công việc', N'Bài tập: Lập kế hoạch tuần', N'Lập kế hoạch tuần làm việc hiệu quả', 6, N'Lập một kế hoạch công việc cho tuần tới, bao gồm các công việc và thời gian thực hiện.'),
   (7, 7, 7, N'Java nâng cao: OOP và JavaFX', N'Bài tập: Tạo ứng dụng Java với GUI', N'Lập trình ứng dụng Java với giao diện người dùng', 7, N'Tạo một ứng dụng Java đơn giản với giao diện người dùng sử dụng JavaFX.'),
   (8, 8, 8, N'Giao tiếp tiếng Anh hàng ngày', N'Bài tập: Thực hành giao tiếp', N'Thực hành các câu giao tiếp hàng ngày', 8, N'Thực hành giao tiếp tiếng Anh trong một tình huống cụ thể như gọi món ăn tại nhà hàng.'),
   (9, 9, 9, N'Nguyên lý cơ bản trong Marketing', N'Bài tập: Phân tích chiến dịch marketing', N'Phân tích chiến dịch marketing của một công ty', 9, N'Chọn một chiến dịch marketing nổi bật và phân tích chiến lược của nó.'),
   (10, 10, 10, N'Phân tích dữ liệu nâng cao với Python', N'Bài tập: Phân tích dữ liệu với Pandas', N'Sử dụng Pandas để xử lý và phân tích dữ liệu', 10, N'Tải dữ liệu CSV và sử dụng Pandas để phân tích dữ liệu và tính toán thống kê.');
INSERT INTO Exercise(Exercise_Order, Lesson_Order, Course_ID, Chapter_Name, Exercise_Title, Exercise_Solution, Exercise_Number_Of_Correct_Answers, Exercise_Content)
VALUES
    (2, 2, 1, N'Cấu trúc dữ liệu trong Python', N'Thao tác với List', N'list = [1,2,3]; print(list[0])', 1, N'Tạo một list và in ra phần tử đầu tiên'),
    (3, 3, 1, N'Cấu trúc dữ liệu trong Python', N'Dictionary operations', N'dict = {"name": "John"}; print(dict["name"])', 1, N'Tạo dictionary và truy xuất giá trị'),
    (4, 4, 1, N'Lập trình hướng đối tượng với Python', N'Tạo Class', N'class Student: pass', 1, N'Tạo một class đơn giản'),
    (5, 5, 1, N'Lập trình hướng đối tượng với Python', N'Inheritance Example', N'class Child(Parent): pass', 1, N'Tạo class con kế thừa từ class cha'),
    (6, 6, 1, N'Xử lý File và Exception', N'Đọc file text', N'with open("file.txt") as f: print(f.read())', 1, N'Đọc nội dung từ file text'),
    (7, 7, 1, N'Xử lý File và Exception', N'Try-Except', N'try: x=1/0\nexcept: print("Error")', 1, N'Xử lý exception khi chia cho 0'),
    (8, 8, 1, N'Làm việc với Database', N'Kết nối SQLite', N'import sqlite3; conn = sqlite3.connect("db.sqlite3")', 1, N'Kết nối đến SQLite database'),
    (9, 9, 1, N'Làm việc với Database', N'Select Query', N'cursor.execute("SELECT * FROM users")', 1, N'Thực hiện truy vấn SELECT');

INSERT INTO Document(Document_ID, Course_ID, Chapter_Name, Document_Author, Document_Title, Document_Size, Document_Type)
VALUES
   (1, 1, N'Giới thiệu Python', N'Nguyễn Văn A', N'Giới thiệu Python cơ bản', 150, 'PDF'),
   (2, 2, N'Cơ bản về HTML và CSS', N'Trần Thị B', N'Tạo trang web với HTML và CSS', 200, 'PDF'),
   (3, 3, N'Kỹ năng thuyết trình hiệu quả', N'Lê Văn C', N'Hướng dẫn thuyết trình hiệu quả', 180, 'PDF'),
   (4, 4, N'Cách sử dụng Photoshop cơ bản', N'Phạm Thị D', N'Hướng dẫn Photoshop cơ bản', 250, 'PDF'),
   (5, 5, N'Hàm và công thức trong Excel', N'Đỗ Thanh E', N'Excel nâng cao: Hàm và công thức', 300, 'PDF'),
   (6, 6, N'Quản lý thời gian trong công việc', N'Hoàng Văn F', N'Quản lý thời gian hiệu quả', 100, 'PDF'),
   (7, 7, N'Java nâng cao: OOP và JavaFX', N'Ngô Thị G', N'Java nâng cao với OOP', 220, 'PDF'),
   (8, 8, N'Giao tiếp tiếng Anh hàng ngày', N'Bùi Văn H', N'Tiếng Anh giao tiếp cơ bản', 150, 'PDF'),
   (9, 9, N'Nguyên lý cơ bản trong Marketing', N'Phan Thị I', N'Marketing căn bản cho người mới', 250, 'PDF'),
   (10, 10, N'Phân tích dữ liệu nâng cao với Python', N'Vũ Minh J', N'Phân tích dữ liệu với Python và Pandas', 300, 'PDF');
INSERT INTO Document(Document_ID, Course_ID, Chapter_Name, Document_Author, Document_Title, Document_Size, Document_Type)
VALUES
    (11, 1, N'Cấu trúc dữ liệu trong Python', N'Python Team', N'Python Data Structures Guide', 250, 'PDF'),
    (12, 1, N'Lập trình hướng đối tượng với Python', N'Python Team', N'OOP in Python', 300, 'PDF'),
    (13, 1, N'Xử lý File và Exception', N'Python Team', N'File Handling in Python', 200, 'PDF'),
    (14, 1, N'Làm việc với Database', N'Python Team', N'Database Operations with Python', 350, 'PDF'),
    (15, 1, N'Giới thiệu Python', N'Python Team', N'Getting Started with Python', 150, 'PDF');

INSERT INTO Test(Test_Order, Chapter_Name, Course_ID, Test_Number_Of_Questions, Test_Solution, Test_TakenTimes, Test_Number_Of_Correct_Answers, Test_Content)
VALUES
    (1, N'Giới thiệu Python', 1, 10, N'Solution 1', 5, 8, N'Câu hỏi kiểm tra kiến thức cơ bản về Python.'),
   (2, N'Cơ bản về HTML và CSS', 2, 20, N'Solution 2', 10, 15, N'Câu hỏi kiểm tra khả năng tạo trang web cơ bản với HTML và CSS.'),
   (3, N'Kỹ năng thuyết trình hiệu quả', 3, 15, N'Solution 3', 8, 12, N'Câu hỏi kiểm tra khả năng thuyết trình hiệu quả và các phương pháp thuyết trình.'),
   (4, N'Cách sử dụng Photoshop cơ bản', 4, 10, N'Solution 4', 7, 9, N'Câu hỏi kiểm tra kiến thức cơ bản về Photoshop và công cụ chỉnh sửa ảnh.'),
   (5, N'Hàm và công thức trong Excel', 5, 12, N'Solution 5', 6, 10, N'Câu hỏi kiểm tra khả năng sử dụng công thức trong Excel.'),
   (6, N'Quản lý thời gian trong công việc', 6, 8, N'Solution 6', 5, 6, N'Câu hỏi kiểm tra các phương pháp quản lý thời gian hiệu quả.'),
   (7, N'Java nâng cao: OOP và JavaFX', 7, 20, N'Solution 7', 9, 16, N'Câu hỏi kiểm tra kiến thức OOP và JavaFX trong lập trình Java.'),
   (8, N'Giao tiếp tiếng Anh hàng ngày', 8, 10, N'Solution 8', 4, 8, N'Câu hỏi kiểm tra khả năng giao tiếp tiếng Anh hàng ngày.'),
   (9, N'Nguyên lý cơ bản trong Marketing', 9, 15, N'Solution 9', 6, 12, N'Câu hỏi kiểm tra các nguyên lý cơ bản trong marketing.'),
   (10, N'Phân tích dữ liệu nâng cao với Python', 10, 20, N'Solution 10', 10, 18, N'Câu hỏi kiểm tra khả năng phân tích dữ liệu với Python và Pandas.');





----------------------------------FUNCTION - TRIGGER - PROCEDURE----------------------------------


-- Thủ tục
--a. Insert: InsertCourse - Thêm một khóa học mới vào bảng Course
GO
CREATE PROCEDURE InsertCourse(
    @p_Course_ID INT,
    @p_Course_Name NVARCHAR(255),
    @p_Course_Status NVARCHAR(255),
    @p_Course_Description NVARCHAR(255),
    @p_Course_Price INT,
    @p_Course_Image TEXT,
    @p_Course_Start_Date DATE,
    @p_Course_End_Date DATE,
    @p_Course_Categories_ID INT
)
AS
BEGIN
    -- Kiểm tra xem danh mục có tồn tại không
    IF NOT EXISTS (
        SELECT 1
        FROM Categories
        WHERE Categories_ID = @p_Course_Categories_ID
    )
    BEGIN
        RAISERROR('Danh mục không tồn tại!', 16, 1);
        RETURN;
    END;

    -- Thêm dữ liệu vào bảng Course
    INSERT INTO Course(
        Course_ID,
        Course_Name,
        Course_Status,
        Course_Description,
        Course_Price,
        Course_Image,
        Course_Start_Date,
        Course_End_Date,
        Course_Categories_ID
    )
    VALUES (
        @P_Course_ID,
        @p_Course_Name,
        @p_Course_Status,
        @p_Course_Description,
        @p_Course_Price,
        @p_Course_Image,
        @p_Course_Start_Date,
        @p_Course_End_Date,
        @p_Course_Categories_ID
    );

    -- Lấy giá trị Course_ID vừa được tạo
    DECLARE @NewCourseID INT;
    SET @NewCourseID = SCOPE_IDENTITY();

    -- Thông báo thành công
    SELECT CONCAT(N'Khóa học "', @p_Course_Name, N'" đã được thêm thành công với Course_ID = ', @NewCourseID, '!');
END;
EXEC InsertCourse 503, N'Lập trình JAVA cơ bản', 'Open', N'Khóa học giúp bạn nắm vững các kiến thức cơ bản về JAVA.', 400, 'java_basic.jpg', '2024-01-01', '2024-06-30', 1;


--b. Update: UpdateCourse - Cập nhật thông tin của một khóa học
GO
CREATE PROCEDURE UpdateCourse(
    @p_Course_ID INT,
    @p_Course_Name NVARCHAR(255),
    @p_Course_Status NVARCHAR(255),
    @p_Course_Description NVARCHAR(255),
    @p_Course_Price INT,
    @p_Course_Image TEXT,
    @p_Course_Start_Date DATE,
    @p_Course_End_Date DATE,
    @p_Course_Categories_ID INT
)
AS
BEGIN
    -- Kiểm tra xem khóa học có tồn tại không
    IF NOT EXISTS (
        SELECT 1
        FROM Course
        WHERE Course_ID = @p_Course_ID
    )
    BEGIN
        RAISERROR('Khóa học không tồn tại!', 16, 1);
        RETURN;
    END;

    -- Kiểm tra xem danh mục có tồn tại không
    IF NOT EXISTS (
        SELECT 1
        FROM Categories
        WHERE Categories_ID = @p_Course_Categories_ID
    )
    BEGIN
        RAISERROR('Danh mục không tồn tại!', 16, 1);
        RETURN;
    END;

    -- Cập nhật thông tin khóa học
    UPDATE Course
    SET
        Course_Name = @p_Course_Name,
        Course_Status = @p_Course_Status,
        Course_Description = @p_Course_Description,
        Course_Price = @p_Course_Price,
        Course_Image = @p_Course_Image,
        Course_Start_Date = @p_Course_Start_Date,
        Course_End_Date = @p_Course_End_Date,
        Course_Categories_ID = @p_Course_Categories_ID
    WHERE Course_ID = @p_Course_ID;

    -- Thông báo thành công
    SELECT CONCAT(N'Khóa học "', @p_Course_Name, N'" đã được cập nhật thành công!');
END;

EXEC UpdateCourse 501, N'Lập trình C++ cơ bản', 'Open', N'Khóa học giúp bạn nắm vững các kiến thức cơ bản về C++.', 500, 'c++_basic.jpg', '2024-01-01', '2024-06-30', 1;
SELECT * FROM Course
WHERE Course_ID=501


--c. Delete: DeleteCourse - Xóa một khóa học khỏi bảng Course

GO
CREATE PROCEDURE DeleteCourse(
    @p_Course_ID INT
)
AS

BEGIN
    -- Kiểm tra xem khóa học có tồn tại không
    IF NOT EXISTS (
        SELECT 1
        FROM Course
        WHERE Course_ID = @p_Course_ID
    )
    BEGIN
        RAISERROR('Khóa học không tồn tại!', 16, 1);
        RETURN;
    END;

    -- Xóa khóa học
    DELETE FROM Course
    WHERE Course_ID = @p_Course_ID;

    -- Thông báo thành công
    SELECT CONCAT(N'Khóa học có Course_ID = ', @p_Course_ID, N' đã được xóa thành công!');
END;
EXEC DeleteCourse 502;





--Trigger

-- Trigger 1: Kiểm tra thời gian bắt đầu và kết thúc của khóa học

GO
CREATE TRIGGER tr_CheckCourseDates
ON Course
INSTEAD OF INSERT
AS
BEGIN
    -- Kiểm tra xem thời gian bắt đầu và kết thúc hợp lệ hay không
    IF EXISTS (SELECT 1 FROM inserted WHERE  Course_Start_Date >= Course_End_Date)
    BEGIN
        RAISERROR('Thời gian bắt đầu phải nhỏ hơn thời gian kết thúc của khóa học.', 16, 1);
        RETURN;
    END;

    -- Thêm dữ liệu mới vào bảng Course nếu hợp lệ
    INSERT INTO Course (Course_ID, Course_Name, Course_Status, Course_Description, Course_Price, Course_Image, Course_Start_Date, Course_End_Date, Course_Categories_ID)
    SELECT Course_ID, Course_Name, Course_Status, Course_Description, Course_Price, Course_Image, Course_Start_Date, Course_End_Date, Course_Categories_ID
    FROM inserted;

    -- Thông báo thành công
    SELECT N'Khóa học đã được thêm thành công!';
END;
INSERT INTO Course(Course_ID, Course_Name, Course_Status, Course_Description, Course_Price, Course_Image, Course_Start_Date, Course_End_Date, Course_Categories_ID)
VALUES
	(100, N'Phân tích dữ liệu với Python', 'Open', N'Khóa học chuyên sâu về phân tích dữ liệu và trực quan hóa với Python.', 800, 'data_analysis.jpg', '2024-09-01', '2024-08-31', 1);



-- Trigger 2: Kiểm tra giá trị giảm giá khi thêm phiếu giảm giá mới
GO
CREATE TRIGGER tr_CheckCouponValue
ON Coupon
INSTEAD OF INSERT
AS
BEGIN
    -- Kiểm tra xem giá trị giảm giá có hợp lệ (không âm) hay không
    IF EXISTS (SELECT 1 FROM inserted WHERE Coupon_Value < 0)
    BEGIN
        RAISERROR(N'Giá trị giảm giá phải là số không âm.', 16, 1);
        RETURN;
    END;

    -- Kiểm tra xem loại giảm giá có hợp lệ hay không
    IF EXISTS (SELECT 1 FROM inserted WHERE Coupon_Type NOT IN ('Percent', 'Fixed'))
    BEGIN
        RAISERROR(N'Loại giảm giá phải là "Percent" hoặc "Fixed".', 16, 1);
        RETURN;
    END;

    -- Kiểm tra xem ngày bắt đầu có nhỏ hơn ngày kết thúc hay không
    IF EXISTS (SELECT 1 FROM inserted WHERE Coupon_Start_Date >= Coupon_Expiry_Date)
    BEGIN
        RAISERROR(N'Ngày bắt đầu phải nhỏ hơn ngày kết thúc.', 16, 1);
        RETURN;
    END;

    -- Kiểm tra xem giá trị giảm giá tối đa có hợp lệ (không âm) hay không
    IF EXISTS (SELECT 1 FROM inserted WHERE Coupon_Max_Discount < 0)
    BEGIN
        RAISERROR(N'Giá trị giảm giá tối đa phải là số không âm.', 16, 1);
        RETURN;
    END;
	-- Kiểm tra xem giá trị giảm giá có lớn hơn giá trị giảm giá tối đa không
	IF EXISTS (SELECT 1 FROM inserted where Coupon_Value>Coupon_Max_Discount)
	BEGIN
		RAISERROR(N'Giảm giá vượt giới hạn', 16,1);
		RETURN;
	END;

    -- Thêm phiếu giảm giá mới vào bảng Coupon nếu hợp lệ
    INSERT INTO Coupon (Coupon_ID, Coupon_Title, Coupon_Value, Coupon_Type, Coupon_Start_Date, Coupon_Expiry_Date, Coupon_Max_Discount)
    SELECT Coupon_ID, Coupon_Title, Coupon_Value, Coupon_Type, Coupon_Start_Date, Coupon_Expiry_Date, Coupon_Max_Discount
    FROM inserted;
    -- Thông báo thành công
    SELECT N'Phiếu giảm giá đã được thêm thành công!';
END;
INSERT INTO Coupon(Coupon_ID, Coupon_Title, Coupon_Value, Coupon_Type, Coupon_Start_Date, Coupon_Expiry_Date, Coupon_Max_Discount)
VALUES
    (1, N'Giảm giá khai trương', -9, 'Percent', '2023-01-01', '2023-12-31', 30);


--trigger 3 mỗi khi thêm phiếu giảm giá vào khóa học thì cập nhật giá khóa học
GO
CREATE TRIGGER tr_UpdateCoursePrice
ON Course_Coupon
AFTER INSERT
AS
BEGIN
    UPDATE cr
    SET Cr.Course_Price =
        CASE
            WHEN c.Coupon_Type = 'Percent'
                THEN cr.Course_Price * (1 - c.Coupon_Value/100.0)
            ELSE
                CASE
                    WHEN cr.Course_Price > c.Coupon_Value
                        THEN cr.Course_Price - c.Coupon_Value
                    ELSE 0
                END
        END
    FROM Course cr
    JOIN inserted i ON cr.Course_ID = i.Course_ID
    JOIN Coupon c ON c.Coupon_ID = i.Coupon_ID;

    SELECT N'Đã cập nhật giá khóa học thành công!';
END;
SELECT * FROM Course
SELECT * FROM Course_Coupon
SELECT * FROM Coupon
INSERT Course_Coupon(Course_ID,Coupon_ID)
VALUES
	(6,5);
SELECT * FROM Course as C
WHERE C.Course_ID=6
-- Thủ tục 1 tính toán các giá trị liên quan khóa học
GO
CREATE PROCEDURE GetCourseStatistics
    @p_Course_ID INT
AS
BEGIN
    -- Khai báo biến để lưu các thống kê
    DECLARE @StudentCount INT,
            @AvgRating FLOAT,
            @LessonCount INT,
            @ExerciseCount INT,
            @DocumentCount INT,
            @TotalDuration INT,
            @TotalRevenue INT

    -- Đếm số học viên đăng ký
    SELECT @StudentCount = COUNT(Student_ID)
    FROM Course_Student
    WHERE Course_ID = @p_Course_ID

    -- Tính điểm đánh giá trung bình
    SELECT @AvgRating = AVG(CAST(Reviews_Score AS FLOAT))
    FROM Reviews
    WHERE Course_ID = @p_Course_ID

    -- Đếm số lượng bài học
    SELECT @LessonCount = COUNT(*)
    FROM Lesson
    WHERE Course_ID = @p_Course_ID

    -- Đếm số lượng bài tập
    SELECT @ExerciseCount = COUNT(*)
    FROM Exercise
    WHERE Course_ID = @p_Course_ID

    -- Đếm số lượng tài liệu
    SELECT @DocumentCount = COUNT(*)
    FROM Document
    WHERE Course_ID = @p_Course_ID

    -- Tính tổng thời lượng khóa học
    SELECT @TotalDuration = SUM(Lesson_Duration)
    FROM Lesson
    WHERE Course_ID = @p_Course_ID

    -- Tính tổng doanh thu
    SELECT @TotalRevenue = SUM(c.Course_Price)
    FROM Course c
    JOIN Course_Order co ON c.Course_ID = co.Course_ID
    JOIN Orders o ON co.Order_ID = o.Orders_ID
    WHERE c.Course_ID = @p_Course_ID
    AND o.Orders_Payment_Status = 'Paid'

    -- Trả về kết quả
    SELECT
        @p_Course_ID AS Course_ID,
        @StudentCount AS Total_Students,
        ISNULL(@AvgRating, 0) AS Average_Rating,
        @LessonCount AS Total_Lessons,
        @ExerciseCount AS Total_Exercises,
        @DocumentCount AS Total_Documents,
        @TotalDuration AS Total_Duration_Minutes,
        ISNULL(@TotalRevenue, 0) AS Total_Revenue
END
EXEC GetCourseStatistics 1



--lọc course theo giá tiền
GO
CREATE PROCEDURE FilterCoursesByPrice
    @p_Min_Price INT = NULL,
    @p_Max_Price INT = NULL
AS
BEGIN
    SELECT
        c.Course_ID,
        c.Course_Name,
        c.Course_Price,
        AVG(CAST(r.Reviews_Score AS FLOAT)) as Average_Rating
    FROM Course c
    LEFT JOIN Reviews r ON c.Course_ID = r.Course_ID
    WHERE
        (@p_Min_Price IS NULL OR c.Course_Price >= @p_Min_Price)
        AND (@p_Max_Price IS NULL OR c.Course_Price <= @p_Max_Price)
    GROUP BY
        c.Course_ID,
        c.Course_Name,
        c.Course_Price
    ORDER BY c.Course_Price ASC;
END;
SELECT * FROM Course
EXEC FilterCoursesByPrice 300, 500;
-- Hàm

-- tính tổng giá tiền của đơn hàng
GO
CREATE FUNCTION CalculateOrderTotal
(
    @OrderID INT
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Total DECIMAL(18,2)

    -- Tính tổng giá các khóa học trong đơn hàng
    SELECT @Total = ISNULL(SUM(c.Course_Price), 0)
    FROM Orders o
    JOIN Course_Order co ON o.Orders_ID = co.Order_ID
    JOIN Course c ON co.Course_ID = c.Course_ID
    WHERE o.Orders_ID = @OrderID

    RETURN @Total
END;

GO

SELECT * FROM Course
SELECT * FROM Course_Order
SELECT * FROM Orders
SELECT dbo.CalculateOrderTotal(1) as "giá trị đơn hàng có id là 1";


GO
CREATE FUNCTION CalculateTestScore
(
    @Test_Order INT,
    @Chapter_Name NVARCHAR(255),
    @Course_ID INT
)
RETURNS DECIMAL(4,2)
AS
BEGIN
    DECLARE @Score DECIMAL(4,2)
    DECLARE @TotalQuestions INT
    DECLARE @CorrectAnswers INT

    -- Lấy thông tin số câu hỏi và số câu đúng từ bảng Test
    SELECT
        @TotalQuestions = Test_Number_Of_Questions,
        @CorrectAnswers = Test_Number_Of_Correct_Answers
    FROM Test
    WHERE Test_Order = @Test_Order
    AND Chapter_Name = @Chapter_Name
    AND Course_ID = @Course_ID

    -- Tính điểm theo công thức
    SET @Score = CASE
        WHEN @TotalQuestions > 0 THEN
            CAST(@CorrectAnswers AS DECIMAL(4,2)) / @TotalQuestions * 10
        ELSE 0
    END

    RETURN @Score
END;
GO
SELECT * FROM Course
SELECT * FROM Chapter
SELECT * FROM Test AS T JOIN Chapter AS C ON T.Chapter_Name=C.Chapter_Name
SELECT dbo.CalculateTestScore(1, N'Giới thiệu Python', 1) as "Điểm bài kiểm tra";
