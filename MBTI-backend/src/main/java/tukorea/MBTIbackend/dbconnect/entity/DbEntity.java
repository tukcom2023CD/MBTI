package tukorea.MBTIbackend.dbconnect.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.ToString;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
/*
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
*/

@Builder
@ToString
@AllArgsConstructor
@NoArgsConstructor
@Entity(name="mbti_product")
public class DbEntity {

    @Id
    @Column(nullable = false, unique = true)
    private String prdno;

    @Column(nullable = false)
    private String allegy ;
}
